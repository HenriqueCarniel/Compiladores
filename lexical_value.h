#ifndef LEXICAL_VALUE_H
#define LEXICAL_VALUE_H

#include <string.h>
#include <stdlib.h>

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

LexicalValue createLexicalValue(char* text, TokenType type, int lineNumber);
void freeLexicalValue(LexicalValue lexicalValue);

#endif