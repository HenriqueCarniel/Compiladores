#ifndef TREE_H
#define TREE_H

#include <stdio.h>
#include "lexical_value.h"
#include "types.h"

Node* createNode(LexicalValue lexicalValue, DataType dataType);
Node* createNodeToFunctionCall(LexicalValue lexicalValue, DataType dataType);
void addChild(Node* parent, Node* child);
Node* getLastChild(Node* parent);
void removeNode(Node* node);
void exporta(Node* node);
void printHeader(Node* node);
void printTree(Node* node);

#endif