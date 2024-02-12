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

void quickSort(int array[], int left, int right)
{
    int i, j, x, y;
     
    i = left;
    j = right;
    x = array[(left + right) / 2];
     
    while(i <= j)
    {
        while(array[i] < x && i < right) i++;
        while(array[j] > x && j > left) j--;

        if(i <= j)
        {
            y = array[i];
            array[i] = array[j];
            array[j] = y;
            i++;
            j--;
        }
    }
     
    if(j > left)
        quickSort(array, left, j);

    if(i < right)
        quickSort(array, i, right);
}

// ===============================
// CONTROL FLOW GRAPH
// ===============================

void addTargetInstructionToLeaderList(int targetLabel, LineLabelList* lineLabelList, IntList* leaderLineInstructionList, IntList* unknownLabelList)
{
    int result = searchLineLabel(targetLabel, lineLabelList);
            
    if (result == -1)
    {
        addNumberToIntList(targetLabel, unknownLabelList);
    }
    else
    {
        addNumberToIntList(result, leaderLineInstructionList);
    }
}

void addNextInstructionToLeaderList(IlocOperationList* operationList, int line, IntList* leaderLineInstructionList)
{
    if (operationList->nextOperationList)
    {
        addNumberToIntList(line + 1, leaderLineInstructionList);
    }
}

void updateLeaderIntructionsWithUnknownLineLabels(IntList* leaderLineInstructionList, IntList* unknownLabelList, LineLabelList* lineLabelList)
{
    IntList* currentLabel = unknownLabelList->nextNumber;
    while (currentLabel)
    {
        int lineLabel = searchLineLabel(currentLabel->number, lineLabelList);
        addNumberToIntList(lineLabel, leaderLineInstructionList);

        currentLabel = currentLabel->nextNumber;
    }
}

void updateStructsToGenerateGraph(IlocOperationList* operationList, LineLabelList* lineLabelList, IntList* unknownLabelList, IntList* leaderLineInstructionList)
{
    IlocOperationList* nextOperationList = operationList;

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
            addTargetInstructionToLeaderList(operation.op1, lineLabelList, leaderLineInstructionList, unknownLabelList);
            addNextInstructionToLeaderList(nextOperationList, line, leaderLineInstructionList);
        }

        if (operation.type == OP_CBR)
        {
            addTargetInstructionToLeaderList(operation.out1, lineLabelList, leaderLineInstructionList, unknownLabelList);
            addTargetInstructionToLeaderList(operation.out2, lineLabelList, leaderLineInstructionList, unknownLabelList);
            addNextInstructionToLeaderList(nextOperationList, line, leaderLineInstructionList);
        }

        if (operation.type != OP_INVALID)
            line++;

        nextOperationList = nextOperationList->nextOperationList;
    }

    LastIntructionLine = line - 1;
    updateLeaderIntructionsWithUnknownLineLabels(leaderLineInstructionList, unknownLabelList, lineLabelList);
}

void generateControlFlowGraph(IlocOperationList* operationList)
{
    LineLabelList* lineLabelList = createLineLabelList();
    IntList* leaderLineInstructionList = createIntList();
    IntList* unknownLabelList = createIntList();

    updateStructsToGenerateGraph(operationList, lineLabelList, unknownLabelList, leaderLineInstructionList);

    int array_size = sizeIntList(leaderLineInstructionList);
    int orderedLeaderInstructionArray[array_size];
    moveIntListToArray(leaderLineInstructionList, orderedLeaderInstructionArray);
    quickSort(orderedLeaderInstructionArray, 0, array_size - 1);

    printCommentedCode(operationList);
    printStartGraph(orderedLeaderInstructionArray, array_size);
    printMiddleGraph(orderedLeaderInstructionArray, array_size, operationList, lineLabelList);
    printEndGraph(orderedLeaderInstructionArray, array_size);
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

void printBlockInstruction(int targetLeaderInstruction, char* startString, char* endString, int orderedLeaderInstructionArray[], int array_size)
{
    int lastIntructionTarget = searchLastBlockIntruction(targetLeaderInstruction, orderedLeaderInstructionArray, array_size);
    endString = allocateBlockString(targetLeaderInstruction, lastIntructionTarget);
    printf("\t%s -> %s; \n", startString, endString);
    free(endString);
}

void printCommentedCode(IlocOperationList* operationList)
{
    printf("# ============== ILOC CODE ============== \n");

    IlocOperationList* nextOperationList = operationList;
    int line = 1;

    while(nextOperationList != NULL)
    {
        IlocOperation operation = nextOperationList->operation;

        if (operation.type != OP_INVALID)
        {
            printf("# %d: ", line);
            generateCodeByOperation(operation);
            line++;
        }

        nextOperationList = nextOperationList->nextOperationList;
    }

    printf("\n");
}

void printStartGraph(int orderedLeaderInstructionArray[], int array_size)
{
    int lastIntructionFirst;
    char* firstBlockString = NULL;

    if (array_size == 1)
    {
        lastIntructionFirst = LastIntructionLine;
    }
    else
    {
        lastIntructionFirst = orderedLeaderInstructionArray[1] - 1;
    }
    firstBlockString = allocateBlockString(1, lastIntructionFirst);

    printf("digraph G { \n");
    printf("\tstart -> %s; \n", firstBlockString);
    free(firstBlockString);
}

void printMiddleGraph(int orderedLeaderInstructionArray[], int array_size, IlocOperationList* operationList, LineLabelList* lineLabelList)
{
    for (int i = 0; i < array_size - 1; i++)
    {
        int currentLeaderInstruction = orderedLeaderInstructionArray[i];
        int nextLeaderInstruction = orderedLeaderInstructionArray[i + 1];
        char* startString = allocateBlockString(currentLeaderInstruction, nextLeaderInstruction - 1);
        char* endString = NULL;

        IlocOperation lastInstructionCurrentBlock = searchOperationByLine(operationList, nextLeaderInstruction - 1);
        if (lastInstructionCurrentBlock.type == OP_CBR)
        {
            int targetLeaderInstruction = searchLineLabel(lastInstructionCurrentBlock.out1, lineLabelList);
            printBlockInstruction(targetLeaderInstruction, startString, endString, orderedLeaderInstructionArray, array_size);

            targetLeaderInstruction = searchLineLabel(lastInstructionCurrentBlock.out2, lineLabelList);
            printBlockInstruction(targetLeaderInstruction, startString, endString, orderedLeaderInstructionArray, array_size);
        }
        else if (lastInstructionCurrentBlock.type == OP_JUMPI)
        {
            int targetLeaderInstruction = searchLineLabel(lastInstructionCurrentBlock.op1, lineLabelList);
            printBlockInstruction(targetLeaderInstruction, startString, endString, orderedLeaderInstructionArray, array_size);
        }
        else
        {
            int targetLeaderInstruction = nextLeaderInstruction;
            printBlockInstruction(targetLeaderInstruction, startString, endString, orderedLeaderInstructionArray, array_size);
        }

        free(startString);
    }
}

void printEndGraph(int orderedLeaderInstructionArray[], int array_size)
{
    int startInstructionLast;
    char* lastBlockString = NULL;

    startInstructionLast = orderedLeaderInstructionArray[array_size - 1];
    lastBlockString = allocateBlockString(startInstructionLast, LastIntructionLine);

    printf("\t%s -> end; \n", lastBlockString);
    printf("} \n");
    
    free(lastBlockString);
}