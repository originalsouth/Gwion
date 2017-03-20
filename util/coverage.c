#include <stdlib.h>
#include <stdio.h>

static unsigned int type_count = 0;
static const char type_decl[1024][1024];
static const char type_name[1024][1024];

int type_index(const char* s) {
	unsigned int i;
	for(i = 0; i < type_count; i++)
		if(!strcmp(s, type_decl[i]))
			return i;
	return -1;
}

int parse(FILE* f) {
	char *line = NULL;
	size_t len = 0;
	ssize_t read;

	while ((read = getline(&line, &len, f)) != -1) {
		if(strstr(line, "struct Type_")) {
			unsigned int i = 12;
			unsigned int j = 0;
			char* c = strstr(line, "struct Type_");
			while(i < read && (c[i] == ' ' || c[i] == '\t'))
				i++;
			while(i+j < read && (c[i+j] != ' ' || c[i+j] == '\t'))
				j++;
			char str[j + 2];
			snprintf(str, j + 1, "%s", c +i);
			strcpy(type_decl[type_count], str);
			char* gw_name = strstr(line, "\"");
			i = 1;
			while(i < strlen (gw_name) && gw_name[i] != '"')
				i++;
			char c2[i+2];
			snprintf(c2, i, "%s", gw_name +1);
			strcpy(type_name[type_count], c2);
			type_count++;
			continue;
		}
		if(strstr(line, "add_global_type")) {
			unsigned int i = 1;
			unsigned int j = 0;
			char* c = strstr(line, "&");
			while(i+j < read && (c[i+j] != ')'))
				j++;
			char str[j+2];
			snprintf(str, j+1, "%s", c+i);
			printf("found new '%s' index: %i.\n", str, type_index(str));
			int index = type_index(str);
			// open new file for writing.
			char filename[strlen(type_name[index])+4];
			sprintf(filename, "%s.gw", type_name[index]);
			printf("should open file '%s' for writing.\n", filename);
			continue;
		}
	}
    free(line);
//	int i;
//	for(i = 0; i < type_count; i++)
//		printf("%s : %s\n", type_decl[i], type_name[i]);
}

int main(int argc, char** argv) {
	FILE *in;
	if(argc < 2) {
		printf("usage: '%s' file (output_diretory, optionnal)\n", argv[0]);
		return 1;
	}
    if(!(in = fopen(argv[1], "r"))) {
		printf("error: can't open '%s' for reading\n", argv[1]);
		return 1;
	}
	parse(in);
	fclose(in);
}
