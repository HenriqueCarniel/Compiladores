#ifndef TYPES_HEADER
#define TYPES_HEADER

// ===============================
// DATA TYPE
// ===============================
typedef enum DataType
{
    DATA_TYPE_INT,
    DATA_TYPE_FLOAT,
    DATA_TYPE_BOOL
} DataType;

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
} Node;

// ===============================
// SIMBOL TABLE
// ===============================
typedef enum SymbolType
{
    SYMBOL_TYPE_LITERAL,
    SYMBOL_TYPE_IDENTIFIER,
    SYMBOL_TYPE_FUNCTION,
    SYMBOL_TYPE_NON_EXISTENT
} SymbolType;

typedef struct SymbolTableValue
{
    int lineNumber;
    SymbolType symbolType;
    DataType dataType;
    LexicalValue lexicalValue;
} SymbolTableValue;

typedef struct SymbolTableEntry
{
    char* key;
    SymbolTableValue value;
} SymbolTableEntry;

typedef struct SymbolTable
{
    int size;
    int capacity;
    SymbolTableEntry* entries;
} SymbolTable;

typedef struct SymbolTableStack
{
    SymbolTable* symbolTable;
    struct SymbolTableStack* nextItem;    
} SymbolTableStack;

#endif