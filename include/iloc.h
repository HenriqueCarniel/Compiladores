#ifndef ILOC_HEADER
#define ILOC_HEADER

#include <stdio.h>
#include <stdlib.h>
#include "types.h"
#include "symbol_table.h"

int generateLabel();
int generateRegister();
IlocOperation generateEmptyOperation();
IlocOperation generateInvalidOperation();
IlocOperation generateNopOperation();
IlocOperation generateOperation(IlocOperationType type, int op1, int op2, int out1, int out2);
IlocOperation addLabelToOperation(IlocOperation operation, int label);
void generateCode(IlocOperationList* operationList);
IlocOperationList* createIlocOperationList();
IlocOperationList* createListFromOtherList(IlocOperationList* operationList);
void addOperationToIlocList(IlocOperationList* operationList, IlocOperation operation);
void addIlocListToIlocList(IlocOperationList* operationList, IlocOperationList* operationListCopy);
IlocOperationList* joinOperationLists(IlocOperationList* operationList1, IlocOperationList* operationList2);
void printOperation(IlocOperation operation);
void printIlocOperationList(IlocOperationList* operationList);
void testOperationAndLists();
void generateAsm(IlocOperationList* operationList);

#endif