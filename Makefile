
main: main.c
	bison -d parser.y
	flex scanner.l
	gcc main.c parser.tab.c lex.yy.c -c
	gcc main.o parser.tab.o lex.yy.o -o etapa2

debug: main.c
	bison -d parser.y --report-file parser.output -Wcounterexamples
	flex scanner.l
	gcc main.c parser.tab.c lex.yy.c -c
	gcc main.o parser.tab.o lex.yy.o -o etapa2

scanner: scanner.l
	flex scanner.l
	gcc flex.yy.c -c

all: main scanner
	gcc lex.yy.o main.o -o etapa2



#all : main

#run : main
#	./etapa2 < entrada.txt

#main: flex main.c
#	gcc main.c -c
#	gcc -o etapa2 lex.yy.o parser.tab.o main.o

#flex: bison scanner.l
#	flex scanner.l
#	gcc -c lex.yy.c

#bison: parser.y
#	bison -d parser.y 
#	gcc -c parser.tab.c

#clean:
#	rm -f *.o etapa2