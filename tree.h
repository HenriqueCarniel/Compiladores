#include <stdio.h>
#include "lexical_value.h"

typedef struct Node
{
    LexicalValue LexicalValue;
    struct Node* parent;
    struct Node* brother;
    struct Node* child;
} Node;

Node* createNode(LexicalValue lexicalValue);
Node* createNodeToFunctionCall(LexicalValue lexicalValue);
void addChild(Node* parent, Node* child);
Node* getLastChild(Node* parent);
void removeNode(Node* node);
void exporta(Node* node);
void printHeader(Node* node);
void printTree(Node* node);