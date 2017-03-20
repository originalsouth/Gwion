#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <pthread.h>
#define COVERAGE_MAX 256

static const char* operators[] = {
	"op_assign", "op_plus", "op_minus", "op_times", "op_divide", "op_percent",
	"op_and", "op_or", "op_eq", "op_neq",
	"op_gt", "op_ge", "op_lt", "op_le",
	"op_shift_left", "op_shift_right",
	"op_s_or", "op_s_and", "op_s_xor",
	"op_plusplus", "op_minusminus", "op_exclamation", "op_tilda",
	"op_new", "op_spork", "op_typeof", "op_sizeof",
	"op_chuck", "op_plus_chuck", "op_minus_chuck", "op_times_chuck", "op_divide_chuck", "op_modulo_chuck",
	"op_rand", "op_ror", "op_req", "op_rneq",
	"op_rgt", "op_rge", "op_rlt", "op_rle",
	"op_rsl", "op_rsr", "op_rsand", "op_rsor", "op_rsxor",
	"op_unchuck", "op_rinc", "op_rdec", "op_runinc", "op_rundec",
	"op_at_chuck", "op_at_unchuck",
	"op_trig", "op_untrig"
};

static const char* op_str[] = {
  "=", "+", "-", "*", "/", "%",
  "&&", "||",   "==", "!=",
  ">", ">=", "<", "<=",
  "<<", ">>",
  "|", "&", "^",
  "++", "--", "!", "~",
  "new", "spork", "typeof", "sizeof",
  "=>", "+=>", "-=>", "*=>", "/=>", "%=>",
  "&&=>", "||=>", "==>", "!=>",
  ">=>", ">==>", "<=<", "<==<",
  "<<=>", ">>=>", "&=>", "|=>", "^=>",
  "=<", "++=>", "--=>", "++=<", "--=<",
  "@=>", "@=<",
  "]=>", "]=<"
};

struct Var
{
	const char* type;
	const char* name;
//	char is_const, is_ref, is_static;
};

struct Arg
{
	const char* type;
	const char* name;
};

struct Func
{
//	const char* type; // ret type
	struct Arg arg[COVERAGE_MAX];
//	char is_static, is_variadic, is_template;
};

struct Type
{
	char* c_name[64];
	char* g_name[64];
//	const char* parent;
	struct Func func[COVERAGE_MAX];
	struct Var  var[COVERAGE_MAX];
};

struct Operator
{
	const char* name;
	const char* sign;
	const char* lhs;
	const char* rhs;
//	const char* ret;
};

struct File
{
	const char* name;
//	struct  Type type[COVERAGE_MAX];
	struct Operator op[COVERAGE_MAX];
};


static struct Type* type[COVERAGE_MAX];
//static char* gw_name[COVERAGE_MAX];
static unsigned int type_count = 0;
static pthread_mutex_t type_lock = PTHREAD_MUTEX_INITIALIZER;


void read_type(const char* c, int read) {
	unsigned int i = 12;
	unsigned int j = 0;
            while(i < read && (c[i] == ' ' || c[i] == '\t'))
                i++;
            while(i+j < read && (c[i+j] != ' ' || c[i+j] == '\t'))
                j++;
            char str[j + 2];
            snprintf(str, j + 1, "%s", c +i);
//            c_name[type_count] = strdup(str);
            char* name = strstr(c, "\"");
            i = 1;
            while(i < strlen (name) && name[i] != '"')
                i++;
            char c2[i+2];
            snprintf(c2, i, "%s", name +1);
 //           gw_name[type_count] = strdup(c2);
//	printf("%s %s\n", c_name[type_count], gw_name[type_count]);
			pthread_mutex_lock(&type_lock);
type[type_count] = malloc(sizeof(struct Type));
//			type[type_count]->c_name = str;
//			type[type_count]->g_name = c2;
			strcpy(type[type_count]->c_name, str);
			strcpy(type[type_count]->g_name, c2);
            type_count++;
			pthread_mutex_unlock(&type_lock);
}

void* parse(void* data) {
	struct File* f = (struct File*)data;
	char *line = NULL;
    size_t len = 0;
    ssize_t read;

//	printf("%s\n", f->name);
	FILE* file = fopen(f->name, "r");
	while((read = getline(&line, &len, file)) != -1) {
		char* c;
		if((c = strstr(line, "struct Type_"))) {
			read_type(c, read);
			continue;
		}
	}
	free(line);
	fclose(file);
free(f);
//	pthread_exit(f->name);
}


int main(int argc, char** argv) {
	int i;
	pthread_t thread[argc -1];
	struct File* f[argc -1];
	for (i = 1; i < argc; i++) {
		f[i-1] = malloc(sizeof(struct File));
		f[i-1]->name = argv[i];
		pthread_create(&thread[i-1], NULL, parse, f[i-1]);
	}
	for (i = 0; i < argc - 1; i++) {
//		char* c;
		pthread_join(thread[i], NULL);
//	printf("%s\n", c);
	}

	for (i = 0; i < type_count; i++) {
//printf("%s\n", type[i].c_name);
//type[i].g_name;
printf("%s %s\n", type[i]->c_name, type[i]->g_name);
//		free(type[i].c_name);
//		free(type[i].g_name);
free(type[i]);
	}

	return 0;
}
