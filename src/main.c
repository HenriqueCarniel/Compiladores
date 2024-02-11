#include <stdio.h>
#include "types.h"
#include "symbol_table.h"
#include "iloc.h"
#include "control_flow_graph.h"

extern int yyparse(void);
extern int yylex_destroy(void);
extern Node* mainFunctionNode;
Node *arvore;
SymbolTableStack* globalSymbolTableStack;

void exporta (void *arvore);
void removeNode (void *arvore);

int main (int argc, char **argv)
{
  
  // Cria a pilha de tabelas de símbolos
  initGlobalSymbolStack();

  int ret = yyparse(); 

  #ifdef DEBUG
    printf("ESCOPO FINAL\n");
    printf("======================\n");
    printf("Frame atual:\n");
    printGlobalTableStack(1);

    printf("GERANDO CÓDIGO INTEIRO\n");
    if (arvore != NULL)
    {
      generateCode(arvore->operationList);
    }
  #endif
  
  // Código da função main
  if (mainFunctionNode->operationList != NULL)
  {
    generateCode(mainFunctionNode->operationList);
  }

  if (mainFunctionNode->operationList != NULL)
  {
    generateControlFlowGraph(mainFunctionNode->operationList);
  }

  arvore = NULL;
  mainFunctionNode = NULL;
  yylex_destroy();
  freeSymbolTableStack(globalSymbolTableStack);

  return ret;
}
