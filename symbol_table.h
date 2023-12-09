#ifndef SYMBOL_TABLE_H
#define SYMBOL_TABLE_H

#include "types.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

extern SymbolTableStack* globalSymbolTableStack;

void initGlobalSymbolStack();

void initGlobalSymbolStack();

/*

    Criação de uma nova pilha de tabela de símbolos

*/
SymbolTableStack* createSymbolTableStack();
/*

    Criação de uma nova tabela de símbolos

*/
SymbolTable* createSymbolTable();
/*

    Criação de um valor de símbolo para a tabela de símbolos

*/
SymbolTableEntryValue createSymbolTableEntryValue(int lineNumber, SymbolNature symbolNature, DataType dataType, LexicalValue lexicalValue);


//////////////////////////////////////////////////////////////


//          OPERAÇÕES COM CHAVES E VALORES


//////////////////////////////////////////////////////////////

// Retorna uma entrada vazia
SymbolTableEntryValue getEmptySymbolTableEntryValue();

// Checa se há um valor associado a uma chave
SymbolTableEntryValue getSymbolTableEntryValueByKey(SymbolTable* table, char* key);

// djba2 hash function
size_t getIndex(size_t capacity, char* key);

int isSameKey(SymbolTableEntry* entry, char* key);


//////////////////////////////////////////////////////////////


//          OPERAÇÕES COM A TABELA DE PILHAS


//////////////////////////////////////////////////////////////

// Adiciona um símbolo a uma tabela de símbolos
void addSymbolToTable(SymbolTable* table, char* key, SymbolTableEntryValue value);

// Verifica se o identificador já foi declarado em uma tabela dada
int isIdentifierInTable(SymbolTable* table, char* identifier);

// Verifica se o identificador já foi declarado nas tabelas da pilhas
// (percorre do topo ao fim da pilha)
int isIdentifierDeclared(LexicalValue lexicalValue);

// Adiciona um identificador à pilha de tabelas
int addIdentifierToTableStack(DataType type, LexicalValue lexval);

SymbolTableStack* addTableToStack(SymbolTableStack* currentFirstTable, SymbolTable* symbolTable);

#endif