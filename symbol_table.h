#ifndef SYMBOL_TABLE_H
#define SYMBOL_TABLE_H

#include "types.h"
#include "lexical_value.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

extern SymbolTableStack* globalSymbolTableStack;

void initGlobalSymbolStack();

void addTableToGlobalStack(SymbolTable* symbolTable);

void popGlobalStack();

void copySymbolsToGlobalStackBelow();

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
SymbolTableEntryValue createSymbolTableEntryValue(SymbolNature symbolNature, DataType dataType, LexicalValue lexicalValue);

/*

    Operações de liberação de memória

*/

void freeSymbolTableEntryValue(SymbolTableEntryValue value);

void freeSymbolTable(SymbolTable* table);

void freeSymbolTableStack(SymbolTableStack* stack);

//////////////////////////////////////////////////////////////


//          OPERAÇÕES COM CHAVES E VALORES


//////////////////////////////////////////////////////////////

// Retorna uma entrada vazia
SymbolTableEntryValue getEmptySymbolTableEntryValue();

// Checa se há um valor associado a uma chave numa tabela
SymbolTableEntryValue getSymbolTableEntryValueByKey(SymbolTable* table, char* key);

// Percorre as tabelas da pilha por um valor associado à chave
SymbolTableEntryValue getSymbolFromStackByKey(char* key);

// djba2 hash function
size_t getIndex(size_t capacity, char* key);

int isSameKey(SymbolTableEntry* entry, char* key);


//////////////////////////////////////////////////////////////


//          OPERAÇÕES COM A TABELA DE PILHAS


//////////////////////////////////////////////////////////////

// Adiciona um símbolo a uma tabela de símbolos

void addSymbolValueToTable(SymbolTable* table, SymbolTableEntryValue value);

void addSymbolValueToGlobalTableStack(SymbolTableEntryValue value);
void addSymbolValueToBelowGlobalTableStack(SymbolTableEntryValue value);

// Verifica se a chave já existe em uma tabela dada
int isKeyInTable(SymbolTable* table, char* key);

// Verifica se o símbolo já foi declarado nas tabelas da pilhas
// (percorre do topo ao fim da pilha)
void checkSymbolDeclared(SymbolTableEntryValue value);

// Verifica se o identificador já foi declarado nas tabelas da pilhas
// (percorre do topo ao fim da pilha)
int isIdentifierDeclared(char* identifier);

//////////////////////////////////////////////////////////////


//          UTILS


//////////////////////////////////////////////////////////////

void printGlobalTableStack(int depth);

DataType inferTypeFromIdentifier(LexicalValue identifier);

void checkIdentifierIsVariable(LexicalValue identifier);
void checkIdentifierIsFunction(LexicalValue identifier);

#endif