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
void quickSort(int a[], int left, int right);

void generateControlFlowGraph(IlocOperationList* operationList);
IlocOperation searchOperationByLine(IlocOperationList* operationList, int searchedLine);
int searchLastBlockIntruction(int leaderInstruction, int orderedLeaderInstructions[], int size);
char* allocateBlockString(int leaderInstruction, int lastInstruction);

#endif