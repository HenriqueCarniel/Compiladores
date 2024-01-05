/* ======= GRUPO A =======
Henrique Carniel da Silva 
Jose Henrique Lima Marques */

%{
    #include <stdio.h>
    #include "tree.h"
    #include "lexical_value.h"
    #include "parser.tab.h"

    #define YYSTYPE LexicalValue
%}

/* nao precisa do -lfl pra compilar */
%option noyywrap

/* habilita contador de linhas */
%option yylineno

white_space [ \t\n\r]
multiline_comment \/\*(\/)*([^/]|[^*/](\/)+)*\*\/
inline_comment "//".*
special_char_operators [-!*/%+<>=]
special_char [{}(),;]

%%

"int"                               { return TK_PR_INT; }
"float"                             { return TK_PR_FLOAT; }
"bool"                              { return TK_PR_BOOL; }
{special_char}                      { return yytext[0]; }
"else"                              { return TK_PR_ELSE; }

"if"                                { yylval.ASTLabel = strndup(yytext, 2); return TK_PR_IF; }
"while"                             { yylval.ASTLabel = strndup(yytext, 5); return TK_PR_WHILE; }
"return"                            { yylval.ASTLabel = strndup(yytext, 6); return TK_PR_RETURN; }
"<="                                { yylval.ASTLabel = strndup(yytext, 2); return TK_OC_LE; }
">="                                { yylval.ASTLabel = strndup(yytext, 2); return TK_OC_GE; }
"=="                                { yylval.ASTLabel = strndup(yytext, 2); return TK_OC_EQ; }
"!="                                { yylval.ASTLabel = strndup(yytext, 2); return TK_OC_NE; }
"&"                                 { yylval.ASTLabel = strndup(yytext, 1); return TK_OC_AND; }
"|"                                 { yylval.ASTLabel = strndup(yytext, 1); return TK_OC_OR; }
{special_char_operators}            { yylval.ASTLabel = strndup(yytext, 1); return yytext[0]; }

"false"             { yylval.LexicalValue = createLexicalValue(yytext, LITERAL, yylineno); return TK_LIT_FALSE; }
"true"              { yylval.LexicalValue = createLexicalValue(yytext, LITERAL, yylineno); return TK_LIT_TRUE; }
[a-z_]+[a-z_0-9]*   { yylval.LexicalValue = createLexicalValue(yytext, IDENTIFIER, yylineno); return TK_IDENTIFICADOR; }
[0-9]+              { yylval.LexicalValue = createLexicalValue(yytext, LITERAL, yylineno); return TK_LIT_INT; }
[0-9]*\.[0-9]+      { yylval.LexicalValue = createLexicalValue(yytext, LITERAL, yylineno); return TK_LIT_FLOAT; }

{white_space}           {}
{inline_comment}        {}
{multiline_comment}     {}

.       { return TK_ERRO; }

%%

int get_line_number()
{
    return yylineno;
}