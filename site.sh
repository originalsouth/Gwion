#!/bin/bash
# deploy site on gh-pages

post()
{
	if echo ./*/ | grep -v "$1" > /dev/null
	then
		echo "first arg must be a directory, or 'run' or 'deploy'"
		return
	fi
	[ -z "$2" ] && echo "'post' needs two arguments." && return
	printf 'FRONTMATTER\nlayout: page\ntitle: %s\ncategories: %s\nFRONTMATTER\n' "$2" "$1" >> "$1/$2.html"
	sed -i 's/FRONTMATTER/---/' "$1/$2.html"
	nano "$1/$2.html"
}

deploy()
{
#	git add .
#	git commit -am 'Pre-deploy commit :smile:'
#	git push
	bundle exec jekyll build --baseurl https://fennecdjay.github.io/Gwion
	mv _site /tmp
	rm .jekyll-metadata
	git checkout gh-pages || { echo "error: gh-pages checkout"; return; }
	rm -rf ./*
	mv /tmp/_site/* .
	git add .
	git commit -am 'Yeah. Built from subdir'
	git push
	rm .jekyll-metadata
	git checkout site || { echo "error: site checkout"; return; }
}

on_int()
{
	sed -i '/base/s/^#//g' _config.yml #uncomment
	rm -rf _site
}
#run the size locally. access with localhost:4000
run()
{
	trap on_int INT
	sed -i '/base/s/^/#/g' _config.yml #comment
	bundle exec jekyll s
}

# remove _site if interupted or ...
trap 'rm -rf _site; exit' INT
trap 'rm -rf _site; exit' QUIT
trap 'rm -rf _site; exit' TERM
trap 'rm -rf _site; exit' EXIT

gw_doc()
{
# maybe construct
	local head desc
	rm -r gw_doc
	cp -r /usr/lib/Gwion/doc/ gw_doc
	for a in gw_doc/*.html
	do
		head=$(grep "<title" < "$a" | sed "s/.*<title>Gwion: \(.*\)<\/title>.*/\1/" | sed "s#/#\/#")
		desc=$(grep "<meta"  < "$a" | sed "s/.*<em>\(.*\)<\/em>/\1/" | sed "s#/#\/#g" | sed "s#</div>##g")
		echo -e "---\nlayout: homepage\ntitle: $head\ncategorie: user\nimage:\n  feature: abstract-1.jpg\n---\n$(cat "$a")" > "$a"
    	sed -i "s/^<h1>.*<\/h1>$/<article>/" "$a"
		sed -i "s/<title>.*<\/title>//" "$a"
    	sed -i "s/<meta http-equiv.*<script>\(.*\)<\/script><em>\(.*\)<\/em>/<body><section>\n<h3>\2<\/h3><h4>$desc<\/h4><article>/" "$a"
		sed -i "s/<^\/section>/<\/article><\/section>/"   "$a"
		sed -i "s/<section class=\"page-header\"><h1 class=\"project-name\">.*<\/h2><\/section>//" "$a"
		sed -i "s/<section class=\"main-content\"><h1 class=\"title\">.*<\/em>/<section class=\"main-content\"><h4>$desc<\/h4>/" "$a"
	done
	echo -e "---\nlayout: homepage\ntitle: Gwion generated doc\ncategorie: user\nimage:\n  feature: abstract-1.jpg\n---\nHomepage for self generated doc." > gw_doc/index.html
echo '
<script src="dynsections.js" type="text/javascript" charset="utf-8"></script><script src="jquery.js" type="text/javascript" charset="utf-8"></script>
<script src="searchdata.js" type="text/javascript" charset="utf-8"></script><link rel="stylesheet" href="gwion.css"><link rel="stylesheet" href="normalize.css">
<link href="search/search.css" rel="stylesheet" type="text/css"/><script src="search/list.js" type="text/javascript" charset="utf-8"></script>
<script src="search/search.js" type="text/javascript" charset="utf-8"></script>
<script type="text/javascript">\$(document).ready(function() { searchBox.OnSelectItem(0); });</script><script type="text/javascript">var searchBox = new SearchBox("searchBox", "search",false,"Search");</script>
<div id="MSearchBox" class="MSearchBoxInactive">  <span class="left">
    <img id="MSearchSelect" src="search/mag_sel.png"      onmouseover="return searchBox.OnSearchSelectShow()"      onmouseout="return searchBox.OnSearchSelectHide()"      alt=""/>
    <input type="text" id="MSearchField" value="Search" accesskey="S" onfocus="searchBox.OnSearchFieldFocus(true)" onblur="searchBox.OnSearchFieldFocus(false)" onkeyup="searchBox.OnSearchFieldChange(event)"/>
  </span>  <span class="right">    <a id="MSearchClose" href="javascript:searchBox.CloseResultsWindow()"><img id="MSearchCloseImg" border="0" sr\$  </span></div><div id="doc-content">
<!-- window showing the filter options -->
<div id="MSearchSelectWindow"     onmouseover="return searchBox.OnSearchSelectShow()"     onmouseout="return searchBox.OnSearchSelectHide()"     onkeydown="return searchBox.OnSearchSelectKey(event)">
<a class="SelectItem" href="javascript:void(0)" onclick="searchBox.OnSelectItem(0)"><span class="SelectionMark">&#160;</span>All</a><a class="SelectItem" href="javascript:void(0)" onclick="searchBox.OnSelectItem(1)">
<span class="SelectionMark">&#160;</span>Core</a>
<a class="SelectItem" href="javascript:void(0)" onclick="searchBox.OnSelectItem(2)"><span class="SelectionMark">&#160;</span>Plugins</a><a class="SelectItem" href="javascript:void(0)" onclick="searchBox.OnSelectItem(2)">
<span class="SelectionMark">&#160;</span>User</a><a class="SelectItem" href="javascript:void(0)" onclick="searchBox.OnSelectItem(2)"><span class="SelectionMark">&#160;</span>Public</a>
<a class="SelectItem" href="javascript:void(0)" onclick="searchBox.OnSelectItem(2)"><span class="SelectionMark">&#160;</span>Private</a></div>
<!-- iframe showing the search results (closed by default) -->
<div id="MSearchResultsWindow"><iframe src="javascript:void(0)" frameborder="0"        name="MSearchResults" id="MSearchResults"></iframe></div></div>' >> gw_doc/index.html
}

c_doc()
{
# todo: import sources
	rm -rf c_doc
	doxygen

	for a in c_doc/*.html
	do
		local content name
		sed -i 's/{%/{ %/' "$a"
		content=$(cat "$a")
		name=$(echo ${a/.html//} | sed "s#/##g" | sed "s#_8#.#" | sed "s#struct\(.*\)#\1#")
        echo -e "---\nlayout: homepage\ntitle: ${name/c_doc/}\nimage:\n  feature: abstract-1.jpg\n---\n" > "$a"
        echo "$content" >> "$a"
	done
	rm -rf search
	cp -r c_doc/search search
}

examples()
{
	rm -rf examples Gwion-examples
	git checkout master -- examples
	mv examples Gwion-examples
	mkdir examples
	for ex in Gwion-examples/*.gw
	do
		NAME=$(basename "${ex/.gw//}")
		echo -e "---\nlayout: default\ntitle: example $NAME\ncategories: [examples]\nimage:\n  feature: abstract-1.jpg\n#  credit:\n#  creditlink:\\n---\n<br>this page documents <b>$NAME.gw</b><br><p>" > "examples/$NAME.html"
		pygmentize -f html "$ex" >> "examples/$NAME.html"
	echo "</p>" >> "examples/$NAME.html"
	done
	echo '---
layout: homepage
title:	{{post.title}}
---
  <h1>Examples</h1>
  <ul class="posts">
{% for post in site.pages %}
	{% if post.categories == "examples" %}
		<li><span><a href="{{ site.baseurl }}{{ post.url }}">{{post.title}}</a></li>
	{% endif %}
{% endfor %}
  </ul>' > examples/index.html


	rm -r Gwion-examples
	echo "put example content, whith highligting"
	echo "you should be done."
}

code()
{
	rm -f /tmp/file.gw
	nano /tmp/file.gw
	pygmentize -f html /tmp/file.gw | xclip -i
	echo "should be"
	pygmentize /tmp/file.gw
	rm -f /tmp/file.gw
}

# parse arguments
#if [ "$#" -lt 1 ]
#then
#	echo "usage: $0 run/send_gist \$2 \$3/deploy/code/examples/post $1 $2/"
#el
if [ "${1}" = 'run' ]
then
	run
elif [ "${1}" = 'gist' ]
then
	send_gist "$2" "$3"
elif [ "${1}" = 'c_doc' ]
then
	c_doc
elif [ "${1}" = 'gw_doc' ]
then
	gw_doc
elif [ "${1}" = 'deploy' ]
then
	deploy
elif [ "${1}" = 'code' ]
then
	code
elif [ "${1}" = 'examples' ]
then
	examples
else
	post "$1" "$2"
fi
