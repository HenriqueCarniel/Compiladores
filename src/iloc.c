#include "iloc.h"

// ===============================
// GENARATE OPERATIONS
// ===============================

int generateLabel()
{
    static int label_count = 1;
    return label_count++;
}

int n_generated_registers = 0;
int generateRegister()
{
    return n_generated_registers++;
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
        printf("l%d:\n", operation.label);
    }

    switch (operation.type)
    {
        // TODO: terminar de implementar o resto das operações

        case OP_NOP:
            printf("# nop \n");
            printf("\tnop\n");
            break;
        case OP_MULT:
            printf("# mult r%d, r%d => r%d \n", operation.op1, operation.op2, operation.out1);
            printf("    movl    _temp_r_%d(%s), %s \n", operation.op1, "%rip", "%edx");
            printf("    imull   _temp_r_%d(%s), %s \n", operation.op2, "%rip", "%eax");
            printf("    movl    %s, _temp_r_%d(%s) \n", "%eax", operation.out1, "%rip");
            break;
        case OP_DIV:
            printf("# div r%d, r%d => r%d \n", operation.op1, operation.op2, operation.out1);
            printf("    movl    _temp_r_%d(%s), %s \n", operation.op1, "%rip", "%edx");
            printf("    cltd \n");
            printf("    idivl   _temp_r_%d(%s), %s \n", operation.op2, "%rip", "%eax");
            printf("    movl    %s, _temp_r_%d(%s) \n", "%eax", operation.out1, "%rip");
            break;
        case OP_NEG:
            printf("# rsubI r%d, 0 => r%d \n", operation.op1, operation.out1);
            printf("    movl    _temp_r_%d(%s), %s \n", operation.op1, "%rip", "%eax");
            printf("    negl    %s \n", "%eax");
            printf("    movl    %s, _temp_r_%d(%s) \n", "%eax", operation.out1, "%rip");
            break;
        case OP_NEG_LOG:
            printf("# xorI r%d, -1 => r%d \n", operation.op1, operation.out1);
            break;
        case OP_SUB:
            printf("# sub r%d, r%d => r%d \n", operation.op1, operation.op2, operation.out1);

            printf("    movl    _temp_r_%d(%s), %s \n", operation.op1, "%rip", "%edx");
            printf("    subl    _temp_r_%d(%s), %s \n", operation.op2, "%rip", "%eax");
            printf("    movl    %s, _temp_r_%d(%s) \n", "%eax", operation.out1, "%rip");
            break;
        case OP_ADD:
            printf("# add r%d, r%d => r%d \n", operation.op1, operation.op2, operation.out1);
            printf("    movl    _temp_r_%d(%s), %s \n", operation.op1, "%rip", "%edx");
            printf("    addl    _temp_r_%d(%s), %s \n", operation.op2, "%rip", "%eax");
            printf("    movl    %s, _temp_r_%d(%s) \n", "%eax", operation.out1, "%rip");
            break;
        case OP_AND:
            printf("# and r%d, r%d => r%d \n", operation.op1, operation.op2, operation.out1);
            break;
        case OP_OR:
            printf("# or r%d, r%d => r%d \n", operation.op1, operation.op2, operation.out1);
            break;
        case OP_CMP_GE:
            printf("# cmp_GE r%d, r%d -> r%d \n", operation.op1, operation.op2, operation.out1);
            break;
        case OP_CMP_LE:
            printf("# cmp_LE r%d, r%d -> r%d \n", operation.op1, operation.op2, operation.out1);
            break;
        case OP_CMP_GT:
            printf("# cmp_GT r%d, r%d -> r%d \n", operation.op1, operation.op2, operation.out1);
            break;
        case OP_CMP_LT:
            printf("# cmp_LT r%d, r%d -> r%d \n", operation.op1, operation.op2, operation.out1);
            break;
        case OP_CMP_NE:
            printf("# cmp_NE r%d, r%d -> r%d \n", operation.op1, operation.op2, operation.out1);
            break;
        case OP_CMP_EQ:
            printf("# cmp_EQ r%d, r%d -> r%d \n", operation.op1, operation.op2, operation.out1);
            break;
        case OP_CBR:
            printf("# cbr r%d -> l%d, l%d \n", operation.op1, operation.out1, operation.out2);
            break;
        case OP_JUMPI:
            printf("# jumpI -> l%d \n", operation.op1);
            printf("\tjmp l%d\n", operation.op1);
            break;
        case OP_LOADI:
            printf("# loadI %d => r%d \n", operation.op1, operation.out1);
            printf("\tmovl $%d, _temp_r_%d(%s)\n", operation.op1, operation.out1, "%rip");
            break;
        case OP_LOADAI_GLOBAL:
            printf("# loadAI rbss, %d => r%d \n", operation.op1, operation.out1);
            printf("\tmovl global%d(%s), %s\n"      , operation.op1/4   , "%rip"            , "%edx");
            printf("\tmovl %s, _temp_r_%d(%s)\n"    , "%edx"            ,operation.out1    , "%rip");
            break;
        case OP_LOADAI_LOCAL:
            printf("# loadAI rfp, %d => r%d \n"     , operation.op1     , operation.out1);
            printf("\tmovl -%d(%s), %s\n"           , operation.op1     , "%rbp"            , "%edx");
            printf("\tmovl %s, _temp_r_%d(%s)\n"    , "%edx"            ,operation.out1     , "%rip");
            break;
        case OP_STOREAI_GLOBAL:
            printf("# storeAI r%d => rbss, %d \n", operation.op1, operation.out1);
            printf("\tmovl _temp_r_%d(%s), %s\n"    , operation.op1     , "%rip"            , "%edx");
            printf("\tmovl %s, global%d(%s)\n"      , "%edx"            , operation.out1 / 4, "%rip");
            //printf("    movl %s(\%ri p), ");
            break;
        case OP_STOREAI_LOCAL:
            printf("# storeAI r%d => rfp, %d \n", operation.op1, operation.out1);
            printf("\tmovl _temp_r_%d(%s), %s\n"    , operation.op1     , "%rip"            , "%edx");
            printf("\tmovl %s, -%d(%s)\n"            , "%edx"            , operation.out1   , "%rbp");
            break;
        case OP_RETURN:
            printf("# return r%d\n", operation.op1);
            printf("\tmovl _temp_r_%d(%s), %s\n", operation.op1, "%rip", "%eax");
            printf("\tpopq %s\n", "%rbp");
            printf("\tret\n");
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

    /*
    printf("\n========== TESTANDO JOIN DE LISTAS ==========\n");
    IlocOperationList* joinList = createIlocOperationList();
    joinList = joinOperationLists(operationList1, operationList2);
    printIlocOperationList(joinList);
    */
}


void generateAsm(IlocOperationList *operationList)
{
    SymbolTable* globalsTable = globalSymbolTableStack->symbolTable;
    // Define variáveis globais e os registradores usados pelo ILOC
    int bucket_idx;
    SymbolTableEntry* entry;
    int i = 0;
    printf(".data\n");
    printf("# Variáveis globais\n");
    for (bucket_idx=0; bucket_idx < globalsTable->n_buckets; bucket_idx++)
    {
        entry = globalsTable->buckets[bucket_idx].entries;
        while (entry != NULL){
            if(entry->value.symbolNature == SYMBOL_NATURE_IDENTIFIER){
                printf( //".globl global%d\n"
                        //"global%d:\n"
                        "global%d:\t.long\t0\n", i);
                i++;
            }
            entry = entry->next;
        }
    }
    printf("# Registradores do ILOC\n");
    for(int i = 0; i < n_generated_registers; i++){
        printf( //".global _temp_r_%d\n"
                //"_temp_r_%d:\n"
                "_temp_r_%d:\t.long\t0\n", i);
    }


    printf( "# -------------------------\n"
            "#  SEGMENTO DE CÓDIGO\n"
            "# -------------------------\n");

    // Adiciona info da main
    printf("\t.text\n\t.globl\tmain\n\t.type\tmain, @function\nmain:\n");
    printf("\tpushq	%s\n", "%rbp");
    printf("\tmovq %s, %s\n", "%rsp","%rbp");

    generateCode(operationList);
    

}
