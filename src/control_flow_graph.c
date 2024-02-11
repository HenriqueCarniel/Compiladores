#include "control_flow_graph.h"

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
