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
    globalSymbolTableStack->symbolTable = createSymbolTable();
}

void addTableToGlobalStack(SymbolTable* symbolTable)
{

    SymbolTableStack* newStackFrame = createSymbolTableStack();
    // Novo frame aponta para o topo da pilha global
    newStackFrame->nextItem = globalSymbolTableStack;
    newStackFrame->symbolTable = symbolTable;
    // O frame se torna o novo topo
    globalSymbolTableStack = newStackFrame;

    // printf("EMPILHANDO NOVO ESCOPO\n");
    // printf("======================\n");

}

void popGlobalStack()
{
    // printf("DESEMPILHANDO NOVO ESCOPO\n");
    // printf("=========================\n");
    // printf("Frame desempilhado:\n");
    // printGlobalTableStack(1);
    
    freeSymbolTable(globalSymbolTableStack->symbolTable);
    globalSymbolTableStack = globalSymbolTableStack->nextItem;

}

// Copia os valores 
void copySymbolsToGlobalStackBelow()
{
    if(globalSymbolTableStack->nextItem == NULL){
        printf("Erro: tentando copiar símbolos para tabela abaixo, mas tabela atual é a global\n");
        exit(1);
    }

    int i;
    for(i=0; i < N_SYMBOL_TABLE_BUCKETS; i++){
        SymbolTableBucket* bucket = &globalSymbolTableStack->symbolTable->buckets[i];
        SymbolTableEntry* last = bucket->entries;

        while(last != NULL){
            addSymbolValueToTable(globalSymbolTableStack->nextItem->symbolTable, last->value);
            last = last->next;
        }
    }
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
    table->buckets = calloc(N_SYMBOL_TABLE_BUCKETS, sizeof(SymbolTableBucket));
    
    int i;
    for(i=0; i<N_SYMBOL_TABLE_BUCKETS;i++){
        table->buckets[i].n = i;
        table->buckets[i].entries = NULL;
    }

    return table;
}
/*

    Criação de um valor de símbolo para a tabela de símbolos

*/
SymbolTableEntryValue createSymbolTableEntryValue(SymbolNature symbolNature, DataType dataType, LexicalValue lexicalValue){
    SymbolTableEntryValue value;

    value.lineNumber = lexicalValue.lineNumber;
    value.symbolNature = symbolNature;
    value.dataType = dataType;
    value.lexicalValue = lexicalValue;
    // Copia a string
    value.lexicalValue.label = strdup(lexicalValue.label);

    return value;
}

void freeSymbolTableEntryValue(SymbolTableEntryValue value){
    // Libera o valor léxico associado
    freeLexicalValue(value.lexicalValue);
}

void freeSymbolTable(SymbolTable* table){
    int i;
    SymbolTableBucket* bucket;
    SymbolTableEntry* entry;
    SymbolTableEntry* nextEntry;
    // Percorre cada bucket e libera suas entradas
    for(i=0; i < N_SYMBOL_TABLE_BUCKETS; i++){
        bucket = &table->buckets[i];
        entry = bucket->entries;
        // Percorre entradas
        while(entry != NULL){
            nextEntry = entry->next;
            free(entry->key);
            freeSymbolTableEntryValue(entry->value);
            free(entry);
            entry = nextEntry;
        }

    }
    free(table->buckets);
    // Libera tabela
    free(table);
}

void freeSymbolTableStack(SymbolTableStack* stack){
    SymbolTableStack* next;
    do{
        next = stack->nextItem;
        freeSymbolTable(stack->symbolTable);
        stack = next;
    }while(stack != NULL);

    free(stack);
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
    while(entry != NULL){
    
        if (isSameKey(entry, key))
        {
            // Match: retorna o valor da entrada
            return entry->value;
        }
        entry = entry->next;
    
    }

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

void addSymbolValueToGlobalTableStack(SymbolTableEntryValue value){
    addSymbolValueToTable(globalSymbolTableStack->symbolTable, value);
}

void addSymbolValueToBelowGlobalTableStack(SymbolTableEntryValue value){
    addSymbolValueToTable(globalSymbolTableStack->nextItem->symbolTable, value);
}


// Adiciona um símbolo a uma tabela de símbolos
void addSymbolValueToTable(SymbolTable* table, SymbolTableEntryValue value){

    // Se não for literal, checa se já foi declarado na tabela
    if (value.symbolNature != SYMBOL_NATURE_LITERAL){
        checkSymbolDeclared(value);
    }
    

    ////////////////////////////
    // CÁLCULO DA CHAVE
    ////////////////////////////
    char* key = strdup(value.lexicalValue.label);;

    ////////////////////////////
    // ADIÇÃO À HASH TABLE
    ////////////////////////////
    
    // Pega o índice do bucket
    size_t index = getIndex(table->n_buckets, key);
    SymbolTableBucket* bucket = &table->buckets[index];
    
    // Aloca uma nova entrada
    SymbolTableEntry* new_entry = malloc(sizeof(SymbolTableEntry));
    new_entry->key = strdup(key);
    new_entry->value = value;
    new_entry->next = NULL;

    // Se já existem elementos no bucket, adiciona ao fim da lista encadeada
    if(bucket->entries != NULL){
        SymbolTableEntry* cur_entry = bucket->entries;
        SymbolTableEntry* last_entry;

        // Percorre lista encadeada até o fim
        do{
            last_entry = cur_entry;
            cur_entry = cur_entry->next;
        }while (cur_entry != NULL);

        // Adiciona a nova entrada ao fim da lista
        last_entry->next = new_entry;

    }
    else{
        bucket->entries = new_entry;
    }

}

// Verifica se a chave já existe em uma tabela dada
int isKeyInTable(SymbolTable* table, char* key){
    SymbolTableEntryValue value = getSymbolTableEntryValueByKey(table, key);
    if (value.symbolNature == SYMBOL_NATURE_NON_EXISTENT){
        return 0;
    }
    return 1;
}

// Verifica se o símbolo já foi declarado nas tabelas da pilhas
// (percorre do topo ao fim da pilha)
void checkSymbolDeclared(SymbolTableEntryValue value){
    
    char* key = value.lexicalValue.label;
    SymbolTableEntryValue found = getSymbolFromStackByKey(key);
    if(found.symbolNature != SYMBOL_NATURE_NON_EXISTENT){
        printf("Erro semântico:\n\t Símbolo \"%s\" (linha %d) foi previamente declarado (linha %d)\n", key, value.lineNumber, found.lineNumber);
        exit(ERR_DECLARED);
    }
}

SymbolTableEntryValue getSymbolFromStackByKey(char* key){
    // Percorre a pilha
    SymbolTableStack* stackTop = globalSymbolTableStack;
    SymbolTableEntryValue value;

    do{
        value = getSymbolTableEntryValueByKey(stackTop->symbolTable, key);
        stackTop = stackTop->nextItem;
    
    }while((stackTop != NULL) && (value.symbolNature == SYMBOL_NATURE_NON_EXISTENT));

    return value;
}

SymbolTable* getTableFromStackWithMatchingKey(char* key){
    // Percorre a pilha
    SymbolTableStack* stackTop = globalSymbolTableStack;
    SymbolTableEntryValue value;

    while(stackTop != NULL && isKeyInTable(stackTop->symbolTable, key)){
        stackTop = stackTop->nextItem;
    }

    return stackTop->symbolTable;
}



//////////////////////////////////////////////////////////////


//          UTILS


//////////////////////////////////////////////////////////////

void printGlobalTableStack(int depth){
    SymbolTableStack* stackTop = globalSymbolTableStack;
    SymbolTable* table;

    int i = depth;
    int j = 0;

    do{
        printf("                FRAME %d\n", j);
        j++;
        int bucket_idx;
        SymbolTableEntry* entry;
        table = stackTop->symbolTable;
        for(bucket_idx=0; bucket_idx < table->n_buckets; bucket_idx++){
            entry = table->buckets[bucket_idx].entries;
            while(entry != NULL){
                char* key = entry->key;
                SymbolTableEntryValue value = entry->value;
                printf("Símbolo=%s ", key);
                char* str_datatype;
                switch(value.dataType){
                    case DATA_TYPE_INT: str_datatype = "int"; break;
                    case DATA_TYPE_FLOAT: str_datatype = "float"; break;
                    case DATA_TYPE_BOOL: str_datatype = "bool"; break;
                    default: str_datatype = "ERROR"; break;
                }
                printf("Tipo=%s ", str_datatype);
                char* str_nature;
                switch(value.symbolNature){
                    case SYMBOL_NATURE_LITERAL: str_datatype = "literal"; break;
                    case SYMBOL_NATURE_IDENTIFIER: str_datatype = "identifier"; break;
                    case SYMBOL_NATURE_FUNCTION: str_datatype = "function"; break;
                    default: "ERROR"; break;
                }
                printf("Natureza=%s ", str_datatype);
                printf("\n");
                entry = entry->next;
            }
        }
        stackTop = stackTop->nextItem;
        i--;

    }while((stackTop != NULL) && (i > 0));

    printf("\n\n");


}

// Infere o tipo de um identificador. Assume que ele já está na tabela,
// checando por erro de não-definição 
DataType inferTypeFromIdentifier(LexicalValue identifier){

    SymbolTableEntryValue value = getSymbolFromStackByKey(identifier.label);
    if(value.symbolNature == SYMBOL_NATURE_NON_EXISTENT){
        printf("Erro semântico: O identificador \"%s\" (linha %d) não foi declarado nesse escopo\n", 
        identifier.label, identifier.lineNumber
        );
        exit(ERR_UNDECLARED);
    }

    return value.dataType;

}

// Checa se um identificador é variável, lançando erro se não
void checkIdentifierIsVariable(LexicalValue identifier){
    SymbolTableEntryValue value = getSymbolFromStackByKey(identifier.label);
    if(value.symbolNature != SYMBOL_NATURE_IDENTIFIER){
        printf("Erro semântico: O identificador \"%s\" (linha %d) foi usado como variável, mas foi declarado como função (linha %d)\n", 
        identifier.label, identifier.lineNumber, value.lineNumber
        );
        exit(ERR_FUNCTION);
    }
}

// Checa se um identificador é função, lançando erro se não
void checkIdentifierIsFunction(LexicalValue identifier){
    SymbolTableEntryValue value = getSymbolFromStackByKey(identifier.label);
    if(value.symbolNature != SYMBOL_NATURE_FUNCTION){
        printf("Erro semântico: O identificador \"%s\" (linha %d) foi usado como função, mas foi declarado como variável (linha %d)\n", 
        identifier.label, identifier.lineNumber, value.lineNumber
        );
        exit(ERR_FUNCTION);
    }
}































