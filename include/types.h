#ifndef TYPES_HEADER
#define TYPES_HEADER
#include <stdio.h>

// ===============================
// DATA TYPE
// ===============================
typedef enum DataType
{
    DATA_TYPE_INT,
    DATA_TYPE_FLOAT,
    DATA_TYPE_BOOL,
    DATA_TYPE_UNDECLARED,
    DATA_TYPE_PLACEHOLDER // Para o que não sabemos fazer ainda
} DataType;

DataType inferTypeFromTypes(DataType t1, DataType t2);


// ===============================
// LEXICAL VALUE
// ===============================
typedef enum TokenType
{
    IDENTIFIER,
    LITERAL,
    OTHERS
} TokenType;

typedef struct LexicalValue
{
    int lineNumber;
    TokenType type;
    char* label;
} LexicalValue;

// ===============================
// LEXICAL TREE
// ===============================
typedef struct Node
{
    LexicalValue lexicalValue;
    DataType dataType;
    struct Node* parent;
    struct Node* brother;
    struct Node* child;

    ///////////////////////// ETAPA 5 /////////////////////////
    struct IlocOperationList* operationList;
    int outRegister;
} Node;

// ===============================
// SYMBOL TABLE
// ===============================

// Natureza de um símbolo
typedef enum SymbolNature
{
    SYMBOL_NATURE_LITERAL,
    SYMBOL_NATURE_IDENTIFIER,
    SYMBOL_NATURE_FUNCTION,
    SYMBOL_NATURE_NON_EXISTENT
} SymbolNature;

// Valores associados a um símbolo na tabela
typedef struct SymbolTableEntryValue
{
    int lineNumber;
    SymbolNature symbolNature;
    DataType dataType;
    LexicalValue lexicalValue;

    ///////////////////////// ETAPA 5 /////////////////////////
    int isGlobal;
    int position;
} SymbolTableEntryValue;

// Uma entrada numa tabela de símbolos. Lista encadeada
typedef struct SymbolTableEntry
{
    char* key;
    SymbolTableEntryValue value;
    struct SymbolTableEntry* next;
} SymbolTableEntry;

// Um bucket da tabela de símbolos (contém todas entradas que mapeiam para um mesmo índice)
typedef struct SymbolTableBucket
{
    int n;
    SymbolTableEntry* entries;
 }SymbolTableBucket;

// Uma tabela de símbolo (um frame da stack)
#define N_SYMBOL_TABLE_BUCKETS 32
typedef struct SymbolTable
{
    int n_buckets;
    SymbolTableBucket* buckets;

    ///////////////////////// ETAPA 5 /////////////////////////
    //int isGlobal;
    int lastPosition;
} SymbolTable;

// Um elemento da pilha de tabelas de símbolos
typedef struct SymbolTableStack
{
    SymbolTable* symbolTable;
    struct SymbolTableStack* nextItem;

    ///////////////////////// ETAPA 5 /////////////////////////
    int isGlobal;
    int lastPosition;
} SymbolTableStack;

// ===============================
// ILOC
// ===============================
typedef enum IlocOperationType
{
    OP_INVALID,
    OP_NOP,
    OP_MULT,
    OP_DIV,
    OP_NEG,
    OP_NEG_LOG,
    OP_SUB,
    OP_ADD,
    OP_AND,
    OP_OR,
    OP_CMP_GE,
    OP_CMP_LE,
    OP_CMP_GT,
    OP_CMP_LT,
    OP_CMP_NE,
    OP_CMP_EQ,
    OP_CBR,
    OP_JUMPI,
    OP_LOADI,
    OP_LOADAI_GLOBAL,
    OP_LOADAI_LOCAL,
    OP_STOREAI_GLOBAL,
    OP_STOREAI_LOCAL
} IlocOperationType;

typedef struct IlocOperation
{
    IlocOperationType type;
    int label;
    int op1;
    int op2;
    int out1;
    int out2;
} IlocOperation;

typedef struct IlocOperationList
{
    IlocOperation operation;
    struct IlocOperationList* nextOperationList;
} IlocOperationList;

///////////////////////// ETAPA 7 /////////////////////////
typedef struct LineLabelList
{
    int label;
    int line;
    struct LineLabelList* nextLineLabel;
} LineLabelList;

typedef struct IntList
{
    int number;
    struct IntList* nextNumber;
} IntList;

#endif