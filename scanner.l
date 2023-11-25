/* ======= GRUPO A =======
Henrique Carniel da Silva 
Jose Henrique Lima Marques */

%{
    #include "parser.tab.h"
    #include "lexical_value.h"

    #define YYSTYPE LexicalValue
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

"int"       { yylval.LexicalValue = createLexicalValue(yytext, OTHERS, yylineno); return TK_PR_INT; }
"float"     { yylval.LexicalValue = createLexicalValue(yytext, OTHERS, yylineno); return TK_PR_FLOAT; }
"bool"      { yylval.LexicalValue = createLexicalValue(yytext, OTHERS, yylineno); return TK_PR_BOOL; }
"if"        { yylval.LexicalValue = createLexicalValue(yytext, OTHERS, yylineno); return TK_PR_IF; }
"else"      { yylval.LexicalValue = createLexicalValue(yytext, OTHERS, yylineno); return TK_PR_ELSE; }
"while"     { yylval.LexicalValue = createLexicalValue(yytext, OTHERS, yylineno); return TK_PR_WHILE; }
"return"    { yylval.LexicalValue = createLexicalValue(yytext, OTHERS, yylineno); return TK_PR_RETURN; }
"<="        { yylval.LexicalValue = createLexicalValue(yytext, OTHERS, yylineno); return TK_OC_LE; }
">="        { yylval.LexicalValue = createLexicalValue(yytext, OTHERS, yylineno); return TK_OC_GE; }
"=="        { yylval.LexicalValue = createLexicalValue(yytext, OTHERS, yylineno); return TK_OC_EQ; }
"!="        { yylval.LexicalValue = createLexicalValue(yytext, OTHERS, yylineno); return TK_OC_NE; }
"&"         { yylval.LexicalValue = createLexicalValue(yytext, OTHERS, yylineno); return TK_OC_AND; }
"|"         { yylval.LexicalValue = createLexicalValue(yytext, OTHERS, yylineno); return TK_OC_OR; }

"false"             { yylval.LexicalValue = createLexicalValue(yytext, LITERAL, yylineno); return TK_LIT_FALSE; }
"true"              { yylval.LexicalValue = createLexicalValue(yytext, LITERAL, yylineno); return TK_LIT_TRUE; }
[a-z_]+[a-z_0-9]*   { yylval.LexicalValue = createLexicalValue(yytext, IDENTIFIER, yylineno); return TK_IDENTIFICADOR; }
[0-9]+              { yylval.LexicalValue = createLexicalValue(yytext, LITERAL, yylineno); return TK_LIT_INT; }
[0-9]*\.[0-9]+      { yylval.LexicalValue = createLexicalValue(yytext, LITERAL, yylineno); return TK_LIT_FLOAT; }

{white_space}           {}
{inline_comment}        {}
{multiline_comment}     {}
{special_char}          { yylval.LexicalValue = createLexicalValue(yytext, OTHERS, yylineno); return yytext[0]; }

.       { return TK_ERRO; }

%%

int get_line_number()
{
    return yylineno;
}