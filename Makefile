# generated by ./configure

# handle base options
PRG ?=gwion
CC ?=gcc
YACC ?=yacc
LEX ?=flex
PREFIX ?=/usr
SOUNDPIPE_LIB ?=C:\projects\Soundpipe\libsoundpipe.a
SOUNDPIPE_INC ?=
LDFLAGS += -lm -ldl -rdynamic -lpthread
CFLAGS += -Iinclude -std=c99 -O3 -mfpmath=sse -mtune=native -fno-strict-aliasing -Wall -pedantic -D_GNU_SOURCE

# handle boolean options
USE_DOUBLE = off
USE_COVERAGE ?= on
USE_MEMCHECK ?= on

# handle definitions
D_FUNC ?= dummy_driver

# handle directories
GWION_ADD_DIR ?= ${PREFIX}/lib/Gwion/add

# handle libraries
DUMMY_D ?= on
SPA_D ?= on
SNDFILE_D ?= on
ALSA_D ?= off
JACK_D ?= off
PORTAUDIO_D ?= off
SOUNDIO_D ?= off

# handle debug
DEBUG_COMPILE ?= off
DEBUG_OPERATOR ?= off
DEBUG_TYPE ?= off
DEBUG_SCAN0 ?= off
DEBUG_SCAN1 ?= off
DEBUG_SCAN2 ?= off
DEBUG_EMIT ?= off
DEBUG_VM ?= off
DEBUG_INSTR ?= on
DEBUG_SHREDULER ?= off
DEBUG_STACK ?= on

# initialize source lists
core_src := $(wildcard core/*.c)
lang_src := $(wildcard lang/*.c)
ugen_src := $(wildcard ugen/*.c)
eval_src := $(wildcard eval/*.c)
drvr_src := drvr/driver.c

# add libraries
ifeq (${DUMMY_D}, on)
CFLAGS += -DHAVE_DUMMY
drvr_src += drvr/dummy.c
else ifeq (${DUMMY_D}, 1)
CFLAGS +=-DHAVE_DUMMY
drvr_src +=drvr/dummy.c
endif
ifeq (${SPA_D}, on)
CFLAGS += -DHAVE_SPA
drvr_src += drvr/spa.c
else ifeq (${SPA_D}, 1)
CFLAGS +=-DHAVE_SPA
drvr_src +=drvr/spa.c
endif
ifeq (${SNDFILE_D}, on)
LDFLAGS += libsndfile-1.0.28\src\.libs\libsndfile.a
CFLAGS += -DHAVE_SNDFILE
drvr_src += drvr/sndfile.c
else ifeq (${SNDFILE_D}, 1)
LDFLAGS += libsndfile-1.0.28\src\.libs\libsndfile.a
CFLAGS +=-DHAVE_SNDFILE
drvr_src +=drvr/sndfile.c
endif
ifeq (${ALSA_D}, on)
LDFLAGS += -lasound
CFLAGS += -DHAVE_ALSA
drvr_src += drvr/alsa.c
else ifeq (${ALSA_D}, 1)
LDFLAGS += -lasound
CFLAGS +=-DHAVE_ALSA
drvr_src +=drvr/alsa.c
endif
ifeq (${JACK_D}, on)
LDFLAGS += -ljack
CFLAGS += -DHAVE_JACK
drvr_src += drvr/jack.c
else ifeq (${JACK_D}, 1)
LDFLAGS += -ljack
CFLAGS +=-DHAVE_JACK
drvr_src +=drvr/jack.c
endif
ifeq (${PORTAUDIO_D}, on)
LDFLAGS += -lportaudio
CFLAGS += -DHAVE_PORTAUDIO
drvr_src += drvr/portaudio.c
else ifeq (${PORTAUDIO_D}, 1)
LDFLAGS += -lportaudio
CFLAGS +=-DHAVE_PORTAUDIO
drvr_src +=drvr/portaudio.c
endif
ifeq (${SOUNDIO_D}, on)
LDFLAGS += -lsoundio
CFLAGS += -DHAVE_SOUNDIO
drvr_src += drvr/soundio.c
else ifeq (${SOUNDIO_D}, 1)
LDFLAGS += -lsoundio
CFLAGS +=-DHAVE_SOUNDIO
drvr_src +=drvr/soundio.c
endif

# add boolean
ifeq (${USE_COVERAGE}, on)
CFLAGS += -ftest-coverage -fprofile-arcs
else ifeq (${USE_COVERAGE}, 1)
CFLAGS += -ftest-coverage -fprofile-arcs
endif
ifeq (${USE_COVERAGE}, on)
LDFLAGS += --coverage
else ifeq (${USE_COVERAGE}, 1)
LDFLAGS += --coverage
endif
ifeq (${USE_MEMCHECK}, on)
CFLAGS += -g
else ifeq (${USE_MEMCHECK}, 1)
CFLAGS += -g
endif
ifeq (${USE_DOUBLE}, on)
CFLAGS += -DUSE_DOUBLE} -DSPFLOAT=double
else ifeq (${USE_DOUBLE}, 1)
CFLAGS +=-DUSE_DOUBLE -DSPFLOAT=double
else
CFLAGS+=-DSPFLOAT=float
endif

# add definitions
CFLAGS+= -DD_FUNC=${D_FUNC}

# add directories
CFLAGS+=-DGWION_ADD_DIR=\"${GWION_ADD_DIR}\"

# add debug flags
ifeq (${DEBUG_COMPILE}, on)
CFLAGS += -DDEBUG_COMPILE
else ifeq (${DEBUG_D_FUNC},  1)
CFLAGS += -DDEBUG_D_FUNC
endif
ifeq (${DEBUG_OPERATOR}, on)
CFLAGS += -DDEBUG_OPERATOR
else ifeq (${DEBUG_D_FUNC},  1)
CFLAGS += -DDEBUG_D_FUNC
endif
ifeq (${DEBUG_TYPE}, on)
CFLAGS += -DDEBUG_TYPE
else ifeq (${DEBUG_D_FUNC},  1)
CFLAGS += -DDEBUG_D_FUNC
endif
ifeq (${DEBUG_SCAN0}, on)
CFLAGS += -DDEBUG_SCAN0
else ifeq (${DEBUG_D_FUNC},  1)
CFLAGS += -DDEBUG_D_FUNC
endif
ifeq (${DEBUG_SCAN1}, on)
CFLAGS += -DDEBUG_SCAN1
else ifeq (${DEBUG_D_FUNC},  1)
CFLAGS += -DDEBUG_D_FUNC
endif
ifeq (${DEBUG_SCAN2}, on)
CFLAGS += -DDEBUG_SCAN2
else ifeq (${DEBUG_D_FUNC},  1)
CFLAGS += -DDEBUG_D_FUNC
endif
ifeq (${DEBUG_EMIT}, on)
CFLAGS += -DDEBUG_EMIT
else ifeq (${DEBUG_D_FUNC},  1)
CFLAGS += -DDEBUG_D_FUNC
endif
ifeq (${DEBUG_VM}, on)
CFLAGS += -DDEBUG_VM
else ifeq (${DEBUG_D_FUNC},  1)
CFLAGS += -DDEBUG_D_FUNC
endif
ifeq (${DEBUG_INSTR}, on)
CFLAGS += -DDEBUG_INSTR
else ifeq (${DEBUG_D_FUNC},  1)
CFLAGS += -DDEBUG_D_FUNC
endif
ifeq (${DEBUG_SHREDULER}, on)
CFLAGS += -DDEBUG_SHREDULER
else ifeq (${DEBUG_D_FUNC},  1)
CFLAGS += -DDEBUG_D_FUNC
endif
ifeq (${DEBUG_STACK}, on)
CFLAGS += -DDEBUG_STACK
else ifeq (${DEBUG_D_FUNC},  1)
CFLAGS += -DDEBUG_D_FUNC
endif

# add soundpipe
#LDFLAGS+=-lsoundpipe
CFLAGS+=

# initialize object lists
core_obj := $(core_src:.c=.o)
lang_obj := $(lang_src:.c=.o)
ugen_obj := $(ugen_src:.c=.o)
eval_obj := $(eval_src:.c=.o)
drvr_obj := $(drvr_src:.c=.o)

ifeq ($(findstring DEBUG,$(CFLAGS)), DEBUG)
DEBUG = 1
endif

ifeq (${DEBUG}, 1)
CFLAGS+=-DDEBUG
endif

LDFLAGS+= ${SOUNDPIPE_LIB}

ifeq ($(shell uname), Linux)
LDFLAGS+=-lrt
endif

all: ${core_obj} ${lang_obj} ${eval_obj} ${ugen_obj} ${drvr_obj}
	${CC} ${core_obj} ${lang_obj} ${eval_obj} ${ugen_obj} ${drvr_obj} ${LDFLAGS} -o ${PRG}

clean:
	@rm -f */*.o */*.gcda */*.gcno gwion

.c.o:
	${CC} ${CFLAGS} -c $< -o $(<:.c=.o)

install: directories
	cp ${PRG} ${PREFIX}

uninstall:
	rm ${PREFIX}/${PRG}

test:
	@bash -c "source util/test.sh; do_test examples tests/error tests/tree tests/sh tests/ugen_coverage | consummer"

parser:
	${YACC} -o eval/parser.c -dv eval/gwion.y -x

lexer:
	${LEX}  -o eval/lexer.c eval/gwion.l

directories:
	mkdir -p ${PREFIX}
	mkdir -p ${GWION_API_DIR} ${GWION_DOC_DIR} ${GWION_TAG_DIR} ${GWION_TOK_DIR} ${GWION_ADD_DIR}
