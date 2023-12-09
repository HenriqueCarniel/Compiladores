#include "tree.h"

Node* createNode(LexicalValue lexicalValue, DataType dataType)
{
    Node* node = malloc(sizeof(Node));

    node->lexicalValue = lexicalValue;
    node->dataType = dataType;
    node->parent = NULL;
    node->brother = NULL;
    node->child = NULL;

    return node;
}

Node* createNodeToFunctionCall(LexicalValue lexicalValue, DataType dataType)
{
    Node* node = createNode(lexicalValue, dataType);

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
    printf("%p [label=\"%s\"];\n", node, node->lexicalValue.label);
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