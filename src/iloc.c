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

void generateCodeByOperation(IlocOperation operation)
{
    if (operation.type != OP_INVALID && operation.label != -1)
    {
        printf("l%d: ", operation.label);
    }

    switch (operation.type)
    {
        // TODO: terminar de implementar o resto das operações

        case OP_NOP:
            printf("nop \n");
            break;
        
        default:
            break;
    }
}

void generateCode(IlocOperationList* operationList)
{
    IlocOperationList* nextOperationList = operationList;
    while(nextOperationList != NULL)
    {
        IlocOperation operation = nextOperationList->operation;
        generateCodeByOperation(operation);
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
    while (lastOperationList->nextOperationList != NULL)
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

void printOperation(IlocOperation operation)
{
    printf("type: %d \n", operation.type);
    printf("label: %d \n", operation.label);
    printf("op1: %d \n", operation.op1);
    printf("op2: %d \n", operation.op2);
    printf("out1: %d \n", operation.out1);
    printf("out2: %d \n", operation.out2);
    printf("========== \n");
}

void printIlocOperationList(IlocOperationList* operationList)
{
    int i = 0;
    while (operationList != NULL)
    {
        printf("========== OPERAÇÃO %d ==========\n", i);
        printOperation(operationList->operation);
        operationList = operationList->nextOperationList;
        i++;
    }
}

void testOperationAndLists()
{
    printf("========== TESTANDO OPERAÇÕES ==========\n");
    IlocOperation operation1 = generateEmptyOperation();
    printOperation(operation1);
    IlocOperation operation2 = generateInvalidOperation();
    printOperation(operation2);

    printf("\n========== TESTANDO LISTAS ==========\n");
    IlocOperationList* operationList1 = createIlocOperationList();
    addOperationToIlocList(operationList1, operation1);
    addOperationToIlocList(operationList1, operation2);
    printf("\n========== LISTA1 ==========\n");
    printIlocOperationList(operationList1);
    IlocOperationList* operationList2 = createIlocOperationList();
    addOperationToIlocList(operationList2, operation2);
    addOperationToIlocList(operationList2, operation1);
    printf("\n========== LISTA2 ==========\n");
    printIlocOperationList(operationList2);

    printf("\n========== TESTANDO JOIN DE LISTAS ==========\n");
    IlocOperationList* joinList = createIlocOperationList();
    joinList = joinOperationLists(operationList1, operationList2);
    printIlocOperationList(joinList);
}