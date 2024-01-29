########################################
#	DIRETÓRIOS E OUTROS CAMINHOS
########################################
SRC_DIR = src
BUILD_DIR = build
INCLUDE_DIR = include
PATH_FLEX_SRC = $(SRC_DIR)/scanner.l
PATH_BISON_SRC = $(SRC_DIR)/parser.y

########################################
#			ARQUIVOS
########################################

SRC = $(shell find $(SRC_DIR) -type f -name "*.c")
SRC += $(SRC_DIR)/parser.tab.c
SRC += $(SRC_DIR)/lex.yy.c 

OBJ = $(patsubst $(SRC_DIR)/%, $(BUILD_DIR)/%, $(SRC:.c=.o))

DEPS += $(shell find $(INCLUDE_DIR) -type f -name "*.h")

########################################
#			CONFIGS
########################################
CC 						= gcc
CFLAGS					= -I$(INCLUDE_DIR)
_CFLAGS_RELEASE 		=
_CFLAGS_DEBUG 			= -g -DDEBUG
BISON_FLAGS				=
_BISON_FLAGS_DEBUG 		= -d --report-file parser.output -W
FLEX_FLAGS				= 
PROGRAM_NAME 			= etapa5

########################################
#			REGRAS
########################################

.PHONY: all release debug clean build

all: release

release: CFLAGS += $(_CFLAGS_RELEASE)
release: build

debug: CFLAGS += $(_CFLAGS_DEBUG)
debug: BISON_FLAGS := $(_BISON_FLAGS_DEBUG)
debug: build

build: $(OBJ)
	$(CC) -o $(PROGRAM_NAME) $^ $(CFLAGS)

clean:
	rm -f $(PROGRAM_NAME)
	rm -f $(BUILD_DIR)/*
	rm -f $(SRC_DIR)/parser.tab.c
	rm -f $(SRC_DIR)/lex.yy.c
	rm -f $(INCLUDE_DIR)/parser.tab.h

# Compilação de código objeto depende de alteração no .c correspondente ou num dos includes
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.c $(DEPS)
	$(CC) -c -o $@ $< $(CFLAGS)

# Arquivo c gerado pelo flex depende de scanner.l
$(SRC_DIR)/lex.yy.c : $(PATH_FLEX_SRC)
	flex -o $@ $<   $(FLEX_FLAGS)

# Arquivo c gerado pelo flex depende de parser.y
$(SRC_DIR)/parser.tab.c: $(PATH_BISON_SRC)
	bison -d $< -o $@ $(BISON_FLAGS)
	mv $(SRC_DIR)/parser.tab.h include
