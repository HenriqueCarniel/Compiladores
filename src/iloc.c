#include "iloc.h"

// ===============================
// GENARATE OPERATIONS
// ===============================

int generateLabel()
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

IlocOperation generateNopOperation()
{
    IlocOperation operation = generateEmptyOperation();
    operation.type = OP_NOP;
    return operation;
}

IlocOperation generateOperation(IlocOperationType type, int op1, int op2, int out1, int out2)
{
    IlocOperation operation = generateEmptyOperation();
    operation.type = type;
    operation.op1 = op1;
    operation.op2 = op2;
    operation.out1 = out1;
    operation.out2 = out2;
    return operation;
}

IlocOperation addLabelToOperation(IlocOperation operation, int label)
{
    operation.label = label;   
    return operation;
}

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
        case OP_MULT:
            printf("mult r%d, r%d => r%d \n", operation.op1, operation.op2, operation.out1);
            break;
        case OP_DIV:
            printf("div r%d, r%d => r%d \n", operation.op1, operation.op2, operation.out1);
            break;
        case OP_NEG:
            printf("rsubI r%d, 0 => r%d \n", operation.op1, operation.out1);
            break;
        case OP_NEG_LOG:
            printf("xorI r%d, -1 => r%d \n", operation.op1, operation.out1);
            break;
        case OP_SUB:
            printf("sub r%d, r%d => r%d \n", operation.op1, operation.op2, operation.out1);
            break;
        case OP_ADD:
            printf("add r%d, r%d => r%d \n", operation.op1, operation.op2, operation.out1);
            break;
        case OP_AND:
            printf("and r%d, r%d => r%d \n", operation.op1, operation.op2, operation.out1);
            break;
        case OP_OR:
            printf("or r%d, r%d => r%d \n", operation.op1, operation.op2, operation.out1);
            break;
        case OP_CMP_GE:
            printf("cmp_GE r%d, r%d -> r%d \n", operation.op1, operation.op2, operation.out1);
            break;
        case OP_CMP_LE:
            printf("cmp_LE r%d, r%d -> r%d \n", operation.op1, operation.op2, operation.out1);
            break;
        case OP_CMP_GT:
            printf("cmp_GT r%d, r%d -> r%d \n", operation.op1, operation.op2, operation.out1);
            break;
        case OP_CMP_LT:
            printf("cmp_LT r%d, r%d -> r%d \n", operation.op1, operation.op2, operation.out1);
            break;
        case OP_CMP_NE:
            printf("cmp_NE r%d, r%d -> r%d \n", operation.op1, operation.op2, operation.out1);
            break;
        case OP_CMP_EQ:
            printf("cmp_EQ r%d, r%d -> r%d \n", operation.op1, operation.op2, operation.out1);
            break;
        case OP_CBR:
            printf("cbr r%d -> l%d, l%d \n", operation.op1, operation.out1, operation.out2);
            break;
        case OP_JUMPI:
            printf("jumpI -> l%d \n", operation.op1);
            break;
        case OP_LOADI:
            printf("loadI %d => r%d \n", operation.op1, operation.out1);
            break;
        case OP_LOADAI_GLOBAL:
            printf("loadAI rbss, %d => r%d \n", operation.op1, operation.out1);
            break;
        case OP_LOADAI_LOCAL:
            printf("loadAI rfp, %d => r%d \n", operation.op1, operation.out1);
            break;
        case OP_STOREAI_GLOBAL:
            printf("storeAI r%d => rbss, %d \n", operation.op1, operation.out1);
            break;
        case OP_STOREAI_LOCAL:
            printf("storeAI r%d => rfp, %d \n", operation.op1, operation.out1);
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

///////////////////////// ETAPA 7 /////////////////////////

// ===============================
// FLOW CONTROL GRAPH
// ===============================

IntList* createIntList()
{
    IntList* intList = malloc(sizeof(IntList));

    if (!intList) return NULL;

    intList->number = -1;
    intList->nextNumber = NULL;

    return intList;
}

void addNumberToIntList(int number, IntList* intList)
{
    if (!intList) return;

    IntList* lastNumber = intList;
    while (lastNumber->nextNumber != NULL)
    {
        // não permite duplicatas
        if (lastNumber->number == number)
            return;

        lastNumber = lastNumber->nextNumber;
    }
    
    IntList* newIntList = createIntList();
    newIntList->number = number;

    lastNumber->nextNumber = newIntList;
}

LineLabelList* createLineLabelList()
{
    LineLabelList* lineLabelList = malloc(sizeof(LineLabelList));

    if (!lineLabelList) return NULL;

    lineLabelList->label = -1;
    lineLabelList->line = -1;
    lineLabelList->nextLineLabel = NULL;

    return lineLabelList;
}

void addLabelAndLineToLabelList(int label, int line, LineLabelList* lineLabelList)
{
    if (!lineLabelList) return;

    LineLabelList* lastLineLabel = lineLabelList;
    while (lastLineLabel->nextLineLabel != NULL)
    {
        lastLineLabel = lastLineLabel->nextLineLabel;
    }

    LineLabelList* newLineLabelList = createLineLabelList();
    newLineLabelList->label = label;
    newLineLabelList->line = line;

    lastLineLabel->nextLineLabel = newLineLabelList;
}

int searchLineLabel(int label, LineLabelList* lineLabelList)
{
    if (!lineLabelList) return -1;

    LineLabelList* currentLineLabel = lineLabelList;
    while (currentLineLabel != NULL)
    {
        if (currentLineLabel->label == label)
            return currentLineLabel->line;

        currentLineLabel = currentLineLabel->nextLineLabel;
    }

    return -1;
}

void printIntList(IntList* intList)
{
    IntList* currentIntList = intList;
    while (currentIntList)
    {
        printf("value: %d \n", currentIntList->number);
        currentIntList = currentIntList->nextNumber;
    }
}

void printLineLabelList(LineLabelList* lineLabelList)
{
    LineLabelList* currentLineLabelList = lineLabelList;
    while (currentLineLabelList)
    {
        printf("label: %d, line: %d \n", currentLineLabelList->label, currentLineLabelList->line);
        currentLineLabelList = currentLineLabelList->nextLineLabel;
    }
}

void generateFlowControlGraph(IlocOperationList* operationList)
{
    IlocOperationList* nextOperationList = operationList;

    LineLabelList* lineLabelList = createLineLabelList();
    IntList* leaderLineInstructionList = createIntList();
    IntList* unknownLabelList = createIntList();

    addNumberToIntList(1, leaderLineInstructionList);

    int line = 1;
    while(nextOperationList != NULL)
    {
        IlocOperation operation = nextOperationList->operation;

        if (operation.type != OP_INVALID && operation.label != -1)
        {
            addLabelAndLineToLabelList(operation.label, line, lineLabelList);
        }

        if (operation.type == OP_JUMPI)
        {
            int result = searchLineLabel(operation.op1, lineLabelList);
            
            if (result == -1)
            {
                addNumberToIntList(operation.op1, unknownLabelList);
            }
            else
            {
                addNumberToIntList(result, leaderLineInstructionList);
            }

            if (nextOperationList->nextOperationList)
            {
                addNumberToIntList(line + 1, leaderLineInstructionList);
            }
        }

        if (operation.type == OP_CBR)
        {
            int result1 = searchLineLabel(operation.out1, lineLabelList);
            int result2 = searchLineLabel(operation.out1, lineLabelList);
            
            if (result1 == -1)
            {
                addNumberToIntList(operation.out1, unknownLabelList);
            }
            else
            {
                addNumberToIntList(result1, leaderLineInstructionList);
            }

            if (result2 == -1)
            {
                addNumberToIntList(operation.out2, unknownLabelList);
            }
            else
            {
                addNumberToIntList(result2, leaderLineInstructionList);
            }

            if (nextOperationList->nextOperationList)
            {
                addNumberToIntList(line + 1, leaderLineInstructionList);
            }
        }

        if (operation.type != OP_INVALID)
            line++;

        nextOperationList = nextOperationList->nextOperationList;
    }

    // Printa lineLabelList
    printf("\n\n============ lineLabelList============\n");
    printLineLabelList(lineLabelList);

    // Printa leaderLineInstructionList
    printf("\n\n============ leaderLineInstructionList[lines] ============\n");
    printIntList(leaderLineInstructionList);

    // Printa unknownLabelList
    printf("\n\n============ unknownLabelList[labels] ============\n");
    printIntList(unknownLabelList);

    IntList* currentLabel = unknownLabelList->nextNumber;
    while (currentLabel)
    {
        int lineLabel = searchLineLabel(currentLabel->number, lineLabelList);
        addNumberToIntList(lineLabel, leaderLineInstructionList);

        currentLabel = currentLabel->nextNumber;
    }

    // Printa leaderLineInstructionList
    printf("\n\n============ leaderLineInstructionList[lines] ============\n");
    printIntList(leaderLineInstructionList);
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

IlocOperationList* createListFromOtherList(IlocOperationList* operationList)
{
    IlocOperationList* newOperationList = createIlocOperationList();

    if (!newOperationList) return NULL;

    IlocOperationList* operationListCopy = operationList;
    while(operationListCopy != NULL)
    {
        addOperationToIlocList(newOperationList, operationListCopy->operation);
        operationListCopy = operationListCopy->nextOperationList;
    }
    return newOperationList;
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
    IlocOperationList* copyOperation = operationListCopy;
    while(copyOperation != NULL)
    {
        addOperationToIlocList(operationList, copyOperation->operation);
        copyOperation = copyOperation->nextOperationList;
    }
}

IlocOperationList* joinOperationLists(IlocOperationList* operationList1, IlocOperationList* operationList2)
{
    if (operationList1 == NULL || operationList2 == NULL) return NULL;

    IlocOperationList* newOperationList = createIlocOperationList();

    addIlocListToIlocList(newOperationList, operationList1);
    addIlocListToIlocList(newOperationList, operationList2);

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

    printf("\noperação 1:\n");
    IlocOperation operation1 = generateOperation(OP_ADD, 1, 2, 3, -1);
    generateCodeByOperation(operation1);

    printf("\noperação 2:\n");
    IlocOperation operation2 = generateOperation(OP_SUB, 3, 4, 5, -1);
    generateCodeByOperation(operation2);



    printf("\n========== TESTANDO LISTAS ==========\n");    

    printf("\nlista 1:\n");
    IlocOperationList* operationList1 = createIlocOperationList();
    addOperationToIlocList(operationList1, operation1);
    addOperationToIlocList(operationList1, operation2);
    generateCode(operationList1);

    printf("\nlista 2:\n");
    IlocOperationList* operationList2 = createIlocOperationList();
    addOperationToIlocList(operationList2, operation2);
    addOperationToIlocList(operationList2, operation1);
    generateCode(operationList2);

    printf("\nlista 3 [cópia da lista 1]:\n");
    IlocOperationList* operationList3 = createListFromOtherList(operationList1);
    generateCode(operationList3);

    printf("\n========== TESTANDO ADD DE LISTAS ==========\n");

    printf("\nlista 1 após adicionar lista 2:\n");
    addIlocListToIlocList(operationList1, operationList2);
    generateCode(operationList1);

    printf("\nlista 2:\n");
    generateCode(operationList2);
}