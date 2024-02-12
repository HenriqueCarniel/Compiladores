#ifndef CONTROL_FLOW_GRAPH_HEADER
#define CONTROL_FLOW_GRAPH_HEADER

#include <stdio.h>
#include <stdlib.h>
#include "types.h"
#include "iloc.h"

int LastIntructionLine;

IntList* createIntList();
void addNumberToIntList(int number, IntList* intList);
int sizeIntList(IntList* intList);
void moveIntListToArray(IntList* intList, int array[]);
LineLabelList* createLineLabelList();
void addLabelAndLineToLabelList(int label, int line, LineLabelList* lineLabelList);
int searchLineLabel(int label, LineLabelList* lineLabelList);
void printIntList(IntList* intList);
void printLineLabelList(LineLabelList* lineLabelList);
void quickSort(int array[], int left, int right);

void addTargetInstructionToLeaderList(int targetLabel, LineLabelList* lineLabelList, IntList* leaderLineInstructionList, IntList* unknownLabelList);
void updateStructsToGenerateGraph(IlocOperationList* operationList, LineLabelList* lineLabelList, IntList* unknownLabelList, IntList* leaderLineInstructionList);
void updateLeaderIntructionsWithUnknownLineLabels(IntList* leaderLineInstructionList, IntList* unknownLabelList, LineLabelList* lineLabelList);

void generateControlFlowGraph(IlocOperationList* operationList);

int searchLastBlockIntruction(int leaderInstruction, int orderedLeaderInstructions[], int size);
char* allocateBlockString(int leaderInstruction, int lastInstruction);
void printBlockInstruction(int targetLeaderInstruction, char* startString, char* endString, int orderedLeaderInstructionArray[], int array_size);
void printCommentedCode(IlocOperationList* operationList);
void printStartGraph(int orderedLeaderInstructionArray[], int array_size);
void printMiddleGraph(int orderedLeaderInstructionArray[], int array_size, IlocOperationList* operationList, LineLabelList* lineLabelList);
void printEndGraph(int orderedLeaderInstructionArray[], int array_size);

#endif