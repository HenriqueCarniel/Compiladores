#include "iloc.h"

// ===============================
// GENARATE OPERATIONS
// ===============================

int generatelabel()
{
    static int label_count = 1;
    return label_count++;
}

int generateRegister()
{
    static int register_count = 1;
    return register_count++;
}

IlocOperation generateEmptyOperation()
{
    IlocOperation operation;
    operation.type = -1;
    operation.label = -1;
    operation.op1 = -1;
    operation.op2 = -1;
    operation.out1 = -1;
    operation.out2 = -1;
    return operation;
}

IlocOperation generateInvalidOperation()
{
    IlocOperation operation = generateEmptyOperation();
    operation.type = OP_INVALID;
    return operation;
}

// TODO: terminar de implementar as funcionalidades necessárias

void generateCode(IlocOperationList* operationList)
{
    IlocOperationList* nextOperationList = operationList;
    while(nextOperationList != NULL)
    {
        IlocOperation operation = nextOperationList->operation;

        // TODO: implementar essa função
        //generateCodeByOperation(operation);

        nextOperationList = nextOperationList->nextOperationList;
    }
}

// ===============================
// ILOC OPERATION LIST
// ===============================

IlocOperationList* createIlocOperationList()
{
    IlocOperationList* operationList = malloc(sizeof(IlocOperationList));

    if (!operationList) return NULL;

    operationList->operation = generateInvalidOperation();
    operationList->nextOperationList = NULL;
    return operationList;
}

void addOperationToIlocList(IlocOperationList* operationList, IlocOperation operation)
{
    if (operationList == NULL) return;

    IlocOperationList* lastOperationList = operationList;
    while (lastOperationList != NULL)
    {
        lastOperationList = lastOperationList->nextOperationList;
    }
    
    IlocOperationList* newOperationList = createIlocOperationList();
    newOperationList->operation = operation;
    lastOperationList->nextOperationList = newOperationList;
}

void addIlocListToIlocList(IlocOperationList* operationList, IlocOperationList* operationListCopy)
{
    while(operationList != NULL)
    {
        addOperationToIlocList(operationListCopy, operationList->operation);
        operationList = operationList->nextOperationList;
    }
}

IlocOperationList* joinOperationLists(IlocOperationList* operationList1, IlocOperationList* operationList2)
{
    if (operationList1 == NULL || operationList2 == NULL) return NULL;

    IlocOperationList* newOperationList = createIlocOperationList();

    addIlocListToIlocList(operationList1, newOperationList);
    addIlocListToIlocList(operationList2, newOperationList);

    return newOperationList;
}