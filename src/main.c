#include <stdio.h>
#include "types.h"
#include "symbol_table.h"

#include "iloc.h"

extern int yyparse(void);
extern int yylex_destroy(void);
void *arvore = NULL;
SymbolTableStack* globalSymbolTableStack;

void exporta (void *arvore);
void removeNode (void *arvore);

int main (int argc, char **argv)
{
  // Cria a pilha de tabelas de símbolos
  initGlobalSymbolStack();

  int ret = yyparse(); 
  //exporta (arvore);
  //removeNode(arvore);
  arvore = NULL;

  yylex_destroy();

  printf("Final stack state:\n");
  printGlobalTableStack(100);

  freeSymbolTableStack(globalSymbolTableStack);

  return ret;

  //testOperationAndLists();
  //printf("\n");

  return 0;
}
