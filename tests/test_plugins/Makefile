INC      = ../../include
CC       ?= gcc

SRC = ${NAME}.c
OBJ = $(SRC:.c=.o)
CFLAGS   = -I${INC} -ftest-coverage -fprofile-arcs

LDFLAGS  = -fPIC --coverage
PREFIX ?= /usr
GWION_ADD_DIR ?= ${PREFIX}/lib/Gwion/add
# os specific
ifeq ($(shell uname), Darwin)
LDFLAGS += -bundle -undefined dynamic_lookup
else
LDFLAGS += -shared -no-undefined
endif

default: ${NAME}.so


${NAME}.so: ${OBJ}
ifeq (${USE_LD}, 1)
	${LD} $^ -o ${NAME}.so ${LDFLAGS}
else
	${CC} $^ -o ${NAME}.so ${LDFLAGS} ..\..\gwion.def
endif


clean:
	rm -f ${OBJ} ${NAME}.so

.c.o:
	${CC} -fPIC ${CFLAGS} -c $< -o $(<:.c=.o)

install: ${NAME}.so
	install ${NAME}.so ${GWION_ADD_DIR}

uninstall:
ifeq ($(shell uname), Darwin)
	rm ${GWION_ADD_DIR}/${NAME}.so
else ifeq ($(shell uname), Linux)
	rm ${GWION_ADD_DIR}/${NAME}.so
else
	rm ${GWION_ADD_DIR}\${NAME}.so
endif
