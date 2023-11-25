#include "lexical_value.h"

LexicalValue createLexicalValue(char* text, TokenType type, int lineNumber)
{
    LexicalValue lexicalValue;
    lexicalValue.lineNumber = lineNumber;
    lexicalValue.type = type;
    lexicalValue.label = strdup(text);

    return lexicalValue;
}

void freeLexicalValue(LexicalValue lexicalValue)
{
    if (!lexicalValuer.label) return;
    free(lexicalValue.label);
    lexicalValue.label = NULL;
}