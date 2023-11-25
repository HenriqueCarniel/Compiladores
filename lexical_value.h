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