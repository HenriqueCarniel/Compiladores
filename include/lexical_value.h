#ifndef LEXICAL_VALUE_H
#define LEXICAL_VALUE_H

#include <string.h>
#include <stdlib.h>
#include "types.h"

LexicalValue createLexicalValue(char* text, TokenType type, int lineNumber);
void freeLexicalValue(LexicalValue lexicalValue);

#endif