#ifndef TREE_H
#define TREE_H

#include <stdio.h>
#include "lexical_value.h"
#include "types.h"

Node* createNodeFromLexicalValue(LexicalValue lexicalValue, DataType dataType);
Node* createNodeFromLabel(char* label, DataType dataType);
Node* createNodeToFunctionCall(LexicalValue lexicalValue, DataType dataType);
void addChild(Node* parent, Node* child);
Node* getLastChild(Node* parent);
void removeNode(Node* node);
void exporta(Node* node);
void printHeader(Node* node);
void printTree(Node* node);

DataType inferTypeFromNode(Node* node);
DataType inferTypeFromNodes(Node* node1, Node* node2);

#endif