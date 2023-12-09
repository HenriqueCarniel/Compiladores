#include "symbol_table.h"
#include "errors.h"

/*

    ESTRUTURA DA PILHA DE TABELAS

                                SymbolTableStack -> SymbolTable
                                    v
                                SymbolTableStack -> SymbolTable
                                    v
    globalSymbolTableStack ->   SymbolTableStack -> SymbolTable

*/


//////////////////////////////////////////////////////////////


//          CRIAÇÃO DE ESTRUTURAS DE DADOS


//////////////////////////////////////////////////////////////

/*

    Cria a pilha global de símbolos

*/

void initGlobalSymbolStack()
{
    globalSymbolTableStack = createSymbolTableStack();
    SymbolTable* globalTable = createSymbolTable();
    globalSymbolTableStack = addTableToStack(globalSymbolTableStack, globalTable);
}

/*

    Criação de uma nova pilha de tabela de símbolos

*/
SymbolTableStack* createSymbolTableStack()
{
    SymbolTableStack* tableStack = malloc(sizeof(SymbolTableStack));
    if(!tableStack) return NULL;

    tableStack->symbolTable = NULL;
    tableStack->nextItem = NULL;
    return tableStack;
}
/*

    Criação de uma nova tabela de símbolos

*/
SymbolTable* createSymbolTable()
{
    SymbolTable* table = malloc(sizeof(SymbolTable));
    if (!table) return NULL;

    table->n_buckets = N_SYMBOL_TABLE_BUCKETS;
    table->buckets = malloc(sizeof(SymbolTableBucket) * N_SYMBOL_TABLE_BUCKETS);

    return table;
}
/*

    Criação de um valor de símbolo para a tabela de símbolos

*/
SymbolTableEntryValue createSymbolTableEntryValue(int lineNumber, SymbolNature symbolNature, DataType dataType, LexicalValue lexicalValue){
    SymbolTableEntryValue value;

    value.lineNumber = lineNumber;
    value.symbolNature = symbolNature;
    value.dataType = dataType;
    value.lexicalValue = lexicalValue;

    return value;
}


//////////////////////////////////////////////////////////////


//          OPERAÇÕES COM CHAVES E VALORES


//////////////////////////////////////////////////////////////

// Retorna uma entrada vazia
SymbolTableEntryValue getEmptySymbolTableEntryValue()
{
    SymbolTableEntryValue value;
    value.symbolNature = SYMBOL_NATURE_NON_EXISTENT;
    return value;
}

// Checa se há um valor associado a uma chave
SymbolTableEntryValue getSymbolTableEntryValueByKey(SymbolTable* table, char* key)
{
    if (!table) return getEmptySymbolTableEntryValue();

    // Pega o índice do bucket
    size_t index = getIndex(table->n_buckets, key);

    // Obtém o bucket associado à chave
    SymbolTableBucket* bucket = &table->buckets[index];

    // Percorre os elementos do bucket até achar match ou o fim do bucket
    SymbolTableEntry* entry = bucket->entries;
    do{
    
        if (isSameKey(entry, key))
        {
            // Match: retorna o valor da entrada
            return entry->value;
        }
        entry = entry->next;
    
    }while(entry != NULL);

    return getEmptySymbolTableEntryValue();
}

// djba2 hash function
size_t getIndex(size_t capacity, char* key)
{
    unsigned long hash = 5381;
    int c;
    while ((c = *key++))
    {
        hash = ((hash << 5) + hash) + c;
    }
    return hash % capacity;
}

int isSameKey(SymbolTableEntry* entry, char* key)
{
    return strcmp(key, entry->key) == 0;
}


//////////////////////////////////////////////////////////////


//          OPERAÇÕES COM A TABELA DE PILHAS


//////////////////////////////////////////////////////////////

// Adiciona um símbolo a uma tabela de símbolos
void addSymbolToTable(SymbolTable* table, char* key, SymbolTableEntryValue value){
    // Pega o índice do bucket
    size_t index = getIndex(table->n_buckets, key);
    SymbolTableBucket* bucket = &table->buckets[index];
    SymbolTableEntry* cur_entry = bucket->entries;
    // Percorre lista encadeada até o fim
    while (cur_entry->next != NULL){
        cur_entry = cur_entry->next;
    }
    // Append de uma nova entrada
    cur_entry->next = malloc(sizeof(SymbolTableEntry));
    strcpy(cur_entry->next->key, key);
    cur_entry->next->value = value;

}

// Verifica se o identificador já foi declarado em uma tabela dada
int isIdentifierInTable(SymbolTable* table, char* identifier){
    SymbolTableEntryValue value = getSymbolTableEntryValueByKey(table, identifier);
    if (value.symbolNature == SYMBOL_NATURE_NON_EXISTENT){
        return 1;
    }
    return 0;
}

// Verifica se o identificador já foi declarado nas tabelas da pilhas
// (percorre do topo ao fim da pilha)
int isIdentifierDeclared(LexicalValue lexicalValue){
    
    char* identifier = lexicalValue.label;
    
    // Percorre a pilha
    SymbolTableStack* stackTop = globalSymbolTableStack;

    do{
        // Verifica se o identificador foi declarado nesta tabela
        if(isIdentifierInTable(stackTop->symbolTable, identifier)){
            // Se sim, print do erro
            SymbolTableEntryValue value = getSymbolTableEntryValueByKey(stackTop->symbolTable, identifier);
            int line_orig = lexicalValue.lineNumber;
            int line_prev_decl = value.lexicalValue.lineNumber;

            printf("(Linha %d) Erro: identificador \"%s\" ja declarado na linha %d\n", line_orig, identifier, line_prev_decl);
            return ERR_DECLARED;
        }
        // Aponta para o próximo elemento da pilha
        stackTop = stackTop->nextItem;
    
    }while(stackTop->nextItem != NULL);

    return 0;

}

// Adiciona um identificador à pilha de tabelas
int addIdentifierToTableStack(DataType type, LexicalValue lexval){

    int retval = isIdentifierDeclared(lexval);

    if (retval != 0) return retval;

    // Adiciona à tabela no topo da pilha
    SymbolTable* stackTopTable = globalSymbolTableStack->symbolTable;

    char* key = lexval.label; // Chave de um identificador = valor de lexval
    SymbolTableEntryValue value = createSymbolTableEntryValue(lexval.lineNumber, SYMBOL_NATURE_IDENTIFIER, type, lexval);
    addSymbolToTable(stackTopTable, key, value);

    return 0;

}


SymbolTableStack* addTableToStack(SymbolTableStack* currentFirstTable, SymbolTable* symbolTable)
{
    if (!currentFirstTable) return NULL;
    if (!symbolTable) return NULL;

    SymbolTableStack* newFirstTable = createSymbolTableStack();
    newFirstTable->symbolTable = symbolTable;
    newFirstTable->nextItem = currentFirstTable;

    return newFirstTable;
}




































