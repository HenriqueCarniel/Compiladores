#ifndef ILOC_HEADER
#define ILOC_HEADER

#include <stdio.h>
#include <stdlib.h>
#include "types.h"

int generatelabel();
int generateRegister();
IlocOperation generateEmptyOperation();
IlocOperation generateInvalidOperation();
// TODO: terminar de implementar as funcionalidades necessárias
void generateCode(IlocOperationList* operationList);
IlocOperationList* createIlocOperationList();
void addOperationToIlocList(IlocOperationList* operationList, IlocOperation operation);
void addIlocListToIlocList(IlocOperationList* operationList, IlocOperationList* operationListCopy);
IlocOperationList* joinOperationLists(IlocOperationList* operationList1, IlocOperationList* operationList2);
void printOperation(IlocOperation operation);
void printIlocOperationList(IlocOperationList* operationList);
void testOperationAndLists();

#endif