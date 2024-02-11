#include "control_flow_graph.h"

// ===============================
// INT LIST
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

int sizeIntList(IntList* intList)
{
    if (!intList) return -1;

    int size = 0;
    IntList* currentNumber = intList;
    while (currentNumber->nextNumber != NULL)
    {
        size++;
        currentNumber = currentNumber->nextNumber;
    }

    return size;
}

void moveIntListToArray(IntList* intList, int array[])
{
    if (!intList) return;

    int i = 0;
    IntList* currentNumber = intList;

    while (currentNumber->nextNumber != NULL)
    {
        array[i] = currentNumber->nextNumber->number;
        currentNumber = currentNumber->nextNumber;
        i++;
    }
}

// ===============================
// LINE LABEL LIST
// ===============================

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

// ===============================
// TESTS
// ===============================

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

// ===============================
// ADDONS
// ===============================

void quickSort(int a[], int left, int right)
{
    int i, j, x, y;
     
    i = left;
    j = right;
    x = a[(left + right) / 2];
     
    while(i <= j) {
        while(a[i] < x && i < right) {
            i++;
        }
        while(a[j] > x && j > left) {
            j--;
        }
        if(i <= j) {
            y = a[i];
            a[i] = a[j];
            a[j] = y;
            i++;
            j--;
        }
    }
     
    if(j > left) {
        quickSort(a, left, j);
    }
    if(i < right) {
        quickSort(a, i, right);
    }
}

// ===============================
// CONTROL FLOW GRAPH
// ===============================

void generateControlFlowGraph(IlocOperationList* operationList)
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
    LastIntructionLine = line - 1;

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

    //////////////////// GERA ARRAY ORDENADO ////////////////////
    int array_size = sizeIntList(leaderLineInstructionList);

    int array[array_size];
    moveIntListToArray(leaderLineInstructionList, array);

    printf("\n\n============ leaderLineInstructionList[lines] quickSort ============\n");
    quickSort(array, 0, array_size - 1);
    for (int i = 0; i < array_size; i++)
    {
        printf("value: %d \n", array[i]);
    }

    //////////////////// GERA GRAFO ////////////////////

    // int searchedLine = 9;
    // IlocOperation searchedOperation = searchOperationByLine(operationList, searchedLine);
    // printf("\n\nline %d: ", searchedLine);
    // generateCodeByOperation(searchedOperation);

    int lastIntructionFirst;
    char* firstBlockString = NULL;

    if (array_size == 1)
    {
        lastIntructionFirst = LastIntructionLine;
    }
    else
    {
        lastIntructionFirst = array[1] - 1;
    }
    firstBlockString = allocateBlockString(1, lastIntructionFirst);

    printf("\n\n\ndigraph G { \n");
    printf("\tstart -> %s; \n", firstBlockString);
    free(firstBlockString);

    for (int i = 0; i < array_size - 1; i++)
    {
        int currentLeaderInstruction = array[i];
        int nextLeaderInstruction = array[i + 1];
        char* startString = allocateBlockString(currentLeaderInstruction, nextLeaderInstruction - 1);
        char* endString = NULL;

        IlocOperation lastInstructionCurrentBlock = searchOperationByLine(operationList, nextLeaderInstruction - 1);
        if (lastInstructionCurrentBlock.type == OP_CBR)
        {
            int targetLeaderInstruction = searchLineLabel(lastInstructionCurrentBlock.out1, lineLabelList);
            int lastIntructionTarget = searchLastBlockIntruction(targetLeaderInstruction, array, array_size);
            endString = allocateBlockString(targetLeaderInstruction, lastIntructionTarget);
            printf("\t%s -> %s; \n", startString, endString);

            free(endString);

            targetLeaderInstruction = searchLineLabel(lastInstructionCurrentBlock.out2, lineLabelList);
            lastIntructionTarget = searchLastBlockIntruction(targetLeaderInstruction, array, array_size);
            endString = allocateBlockString(targetLeaderInstruction, lastIntructionTarget);
            printf("\t%s -> %s; \n", startString, endString);
        }
        else if (lastInstructionCurrentBlock.type == OP_JUMPI)
        {
            int targetLeaderInstruction = searchLineLabel(lastInstructionCurrentBlock.op1, lineLabelList);
            int lastIntructionTarget = searchLastBlockIntruction(targetLeaderInstruction, array, array_size);
            endString = allocateBlockString(targetLeaderInstruction, lastIntructionTarget);
            printf("\t%s -> %s; \n", startString, endString);
        }
        else
        {
            int targetLeaderInstruction = nextLeaderInstruction;
            int lastIntructionTarget;

            if (i < array_size - 2)
                lastIntructionTarget = array[i + 2] - 1;
            else
                lastIntructionTarget = LastIntructionLine;

            endString = allocateBlockString(targetLeaderInstruction, lastIntructionTarget);
            printf("\t%s -> %s; \n", startString, endString);
        }

        free(startString);
        free(endString);
    }

    int startInstructionLast;;
    char* lastBlockString = NULL;

    if (array_size == 1)
    {
        startInstructionLast = 1;
    }
    else
    {
        startInstructionLast = array[array_size - 1];
    }
    lastBlockString = allocateBlockString(startInstructionLast, LastIntructionLine);

    printf("\t%s -> end; \n", lastBlockString);
    printf("} \n");
    
    free(lastBlockString);
}

IlocOperation searchOperationByLine(IlocOperationList* operationList, int searchedLine)
{
    int line = 1;
    IlocOperationList* nextOperationList = operationList;

    while (line < searchedLine)
    {
        if (nextOperationList->operation.type != OP_INVALID)
            line++;
            
        nextOperationList = nextOperationList->nextOperationList;
    }

    return nextOperationList->operation;
}

int searchLastBlockIntruction(int leaderInstruction, int orderedLeaderInstructions[], int size)
{
    for (int i = 0; i < size; i++)
    {
        if (leaderInstruction == orderedLeaderInstructions[i])
        {
            if (i != size - 1)
                return orderedLeaderInstructions[i + 1] - 1;
            else
                return LastIntructionLine;
        }
    }

    return -1;
}

char* allocateBlockString(int leaderInstruction, int lastInstruction)
{
    char *blockString;
    int stringSize;

    if (leaderInstruction - lastInstruction == 0)
    {
        stringSize = snprintf(NULL, 0, "\"%d\"", leaderInstruction);
        if (stringSize < 0) return NULL;

        blockString = malloc(stringSize + 1);
        if (blockString == NULL) return NULL;

        snprintf(blockString, stringSize + 1, "\"%d\"", leaderInstruction);
    }
    else
    {
        stringSize = snprintf(NULL, 0, "\"%d-%d\"", leaderInstruction, lastInstruction);
        if (stringSize < 0) return NULL;

        blockString = malloc(stringSize + 1);
        if (blockString == NULL) return NULL;

        snprintf(blockString, stringSize + 1, "\"%d-%d\"", leaderInstruction, lastInstruction);
    }

    return blockString;
}