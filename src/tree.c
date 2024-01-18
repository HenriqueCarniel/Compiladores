#include "tree.h"

Node* createNodeFromLexicalValue(LexicalValue lexicalValue, DataType dataType)
{
    Node* node = malloc(sizeof(Node));

    node->lexicalValue = lexicalValue;
    node->dataType = dataType;
    node->parent = NULL;
    node->brother = NULL;
    node->child = NULL;

    ///////////////////////// ETAPA 5 /////////////////////////
    node->operationList = NULL;
    node->outRegister = -1;

    return node;
}

Node* createNodeFromLabel(char* label, DataType dataType)
{
    Node* node = malloc(sizeof(Node));

    node->lexicalValue.label = label;
    node->lexicalValue.lineNumber = -1;
    node->lexicalValue.type = OTHERS;
    
    node->dataType = dataType;
    node->parent = NULL;
    node->brother = NULL;
    node->child = NULL;

    ///////////////////////// ETAPA 5 /////////////////////////
    node->operationList = NULL;
    node->outRegister = -1;

    return node;
}


Node* createNodeToFunctionCall(LexicalValue lexicalValue, DataType dataType)
{
    Node* node = createNodeFromLexicalValue(lexicalValue, dataType);

    char* start = "call ";
    char* newLabel = malloc(strlen(start) + strlen(node->lexicalValue.label) + 1);

    strcpy(newLabel, start);
    strcat(newLabel, node->lexicalValue.label);

    free(node->lexicalValue.label);
    node->lexicalValue.label = newLabel;

    return node;
}

void addChild(Node* parent, Node* child)
{
    if (!child) return;

    if (!parent)
    {
        removeNode(child);
        return;
    }

    Node* lastChild = getLastChild(parent);
    if (lastChild)
    {
        lastChild->brother = child;
    }
    else
    {
        parent->child = child;
    }
    child->parent = parent;
}

Node* getLastChild(Node* parent)
{
    Node* currentChild = NULL;
    Node* lastChild = parent->child;
    while (lastChild)
    {
        currentChild = lastChild;
        lastChild = lastChild->brother;
    }
    return currentChild;
}

void removeNode(Node* node)
{
    if (!node) return;

    freeLexicalValue(node->lexicalValue);

    removeNode(node->child);
    removeNode(node->brother);

    free(node);
}

void exporta(Node* node)
{
    if (!node) return;

    printHeader(node);
    printTree(node);
}

void printHeader(Node* node)
{
    const char* type_str;
    switch (node->dataType)
    {
    case DATA_TYPE_INT:
        type_str = "int";
        break;
    case DATA_TYPE_FLOAT:
        type_str = "float";
        break;
    case DATA_TYPE_BOOL:
        type_str = "bool";
        break;
    case DATA_TYPE_PLACEHOLDER:
        type_str = "placeholder";
        break;
    default:
        type_str = "ERROR";
        break;
    }

    printf("%p [label=\"%s\" type=\"%s\"];\n", node, node->lexicalValue.label, type_str);
    if (node->child)
    {
        printHeader(node->child);
    }
    if (node->brother)
    {
        printHeader(node->brother);
    }
}

void printTree(Node* node)
{
    if (node->parent)
    {
        printf("%p, %p\n", node->parent, node);
    }
    if (node->child)
    {
        printTree(node->child);
    }
    if (node->brother)
    {
        printTree(node->brother);
    }
}

// Infere tipo a partir de um nodo
DataType inferTypeFromNode(Node* node){
    return node->dataType;
}

// Infere tipo a partir de dois nodos
DataType inferTypeFromNodes(Node* node1, Node* node2){
    DataType inferred_type = inferTypeFromTypes(node1->dataType, node2->dataType);

    return inferred_type;

}