main: main.c
	bison -d parser.y
	flex scanner.l
	gcc main.c lexical_value.c tree.c parser.tab.c lex.yy.c symbol_table.c -c # gera main.o
	gcc main.o lexical_value.o tree.o parser.tab.o lex.yy.o symbol_table.o -o etapa4

debug: main.c
	bison -d parser.y --report-file parser.output -Wcounterexamples
	flex scanner.l
	gcc -g main.c lexical_value.c tree.c parser.tab.c lex.yy.c symbol_table.c -c # gera main.o
	gcc -g main.o lexical_value.o tree.o parser.tab.o lex.yy.o symbol_table.o -o etapa4

scanner: scanner.l
	flex scanner.l
	gcc lex.yy.c -c #gera lex.yy.o

all: main scanner
	gcc lex.yy.o main.o -o etapa3