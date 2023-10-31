%{
    #include "parser.tab.h"
%}

/* nao precisa do -lfl pra compilar */
%option noyywrap

/* habilita contador de linhas */
%option yylineno

white_space [ \t\n\r]
multiline_comment \/\*(\/)*([^/]|[^*/](\/)+)*\*\/
inline_comment "//".*
special_char [-!*/%+<>{}()=,;]

%%

"int"       { return TK_PR_INT; }
"float"     { return TK_PR_FLOAT; }
"bool"      { return TK_PR_BOOL; }
"if"        { return TK_PR_IF; }
"else"      { return TK_PR_ELSE; }
"while"     { return TK_PR_WHILE; }
"return"    { return TK_PR_RETURN; }
"<="        { return TK_OC_LE; }
">="        { return TK_OC_GE; }
"=="        { return TK_OC_EQ; }
"!="        { return TK_OC_NE; }
"&"         { return TK_OC_AND; }
"|"         { return TK_OC_OR; }

"false"             { return TK_LIT_FALSE; }
"true"              { return TK_LIT_TRUE; }
[a-z_]+[a-z_0-9]*   { return TK_IDENTIFICADOR; }
[0-9]+              { return TK_LIT_INT; }
[0-9]*\.[0-9]+      { return TK_LIT_FLOAT; }

{white_space}           {}
{inline_comment}        {}
{multiline_comment}     {}
{special_char}          { return yytext[0]; }

.       { return TK_ERRO; }

%%

int get_line_number()
{
    return yylineno;
}