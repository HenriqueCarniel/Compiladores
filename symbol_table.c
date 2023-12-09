#include "symbol_table.h"

extern Node* tree;
extern SymbolTableStack* symbolTableStack;

void initGlobalSymbolStack()
{
    symbolTableStack = createSymbolTableStack();
    SymbolTable* globalTable = createSymbolTable();
    symbolTableStack = addTableToStack(symbolTableStack, globalTable);
}

SymbolTableStack* createSymbolTableStack()
{
    SymbolTableStack* tableStack = malloc(sizeof(SymbolTableStack));
    if(!tableStack) return NULL;

    tableStack->symbolTable = NULL;
    tableStack->nextItem = NULL;
    return tableStack;
}

SymbolTable* createSymbolTable()
{
    SymbolTable* table = malloc(sizeof(SymbolTable));
    if (!table) return NULL;

    table->capacity = SYMBOL_TABLE_INITIAL_CAPACITY;
    table->size = 0;
    table->entries = calloc(table->capacity, sizeof(SymbolTableEntry));

    if (!table->entries)
    {
        //freeSymbolTable(table);
        return NULL;
    }

    return table;
}

SymbolTableStack addTableToStack(SymbolTableStack* currentFirstTable, SymbolTable* symbolTable)
{
    if (!currentFirstTable) return NULL;
    if (!symbolTable) return NULL;

    SymbolTableStack* newFirstTable = createSymbolTableStack();
    newFirstTable->symbolTable = symbolTable;
    newFirstTable->nextItem = currentFirstTable;

    return newFirstTable;
}

SymbolTableValue getSymbolTableValueByKey(SymbolTable* table, char* key)
{
    if (!table) return getEmptySymbolTableValue();

    size_t index = getIndex(table->capacity, key);
    SymbolTableEntry possibleEntry = table->entries[index];

    // Trata as colisoes com enderecamento aberto
    size_t current_index = index;
    while (current_index - index <= table->capacity)
    {
        if (isSameKey(possibleEntry, key))
        {
            return possibleEntry.value;
        }

        current_index++;
        possibleEntry = table->entries[current_index % table->capacity];
    }

    return getEmptySymbolTableValue();
}

SymbolTableValue getEmptySymbolTableValue()
{
    SymbolTableValue value;
    value.symbolType = SYMBOL_TYPE_NON_EXISTENT;
    return value;
}

// djba2 hash function
size_t getIndex(int capacity, char* key)
{
    unsigned long hash = 5381;
    int c;
    while ((c = *str++))
    {
        hash = ((hash << 5) + hash) + c;
    }
    return hash % capacity;
}

int isSameKey(SymbolTableEntry entry, char* key)
{
    return strcmp(key, entry.key) == 0;
}



































