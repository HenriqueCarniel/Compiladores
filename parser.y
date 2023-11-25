/* ======= GRUPO A =======
Henrique Carniel da Silva 
Jose Henrique Lima Marques */

%{
#include <stdio.h>
#include "tree.h"
#include "lexical_value.h"

int yylex(void);
void yyerror (char const *mensagem);
int get_line_number();
extern void *arvore;
%}

%code requires
{
    #include "tree.h"
    #include "lexical_value.h"
}

%union
{
    LexicalValue LexicalValue;
    struct Node* Node;
}

%define parse.error verbose

%token<LexicalValue> TK_PR_INT
%token<LexicalValue> TK_PR_FLOAT
%token<LexicalValue> TK_PR_BOOL
%token<LexicalValue> TK_PR_IF
%token<LexicalValue> TK_PR_ELSE
%token<LexicalValue> TK_PR_WHILE
%token<LexicalValue> TK_PR_RETURN
%token<LexicalValue> TK_OC_LE
%token<LexicalValue> TK_OC_GE
%token<LexicalValue> TK_OC_EQ
%token<LexicalValue> TK_OC_NE
%token<LexicalValue> TK_OC_AND
%token<LexicalValue> TK_OC_OR
%token<LexicalValue> TK_IDENTIFICADOR
%token<LexicalValue> TK_LIT_INT
%token<LexicalValue> TK_LIT_FLOAT
%token<LexicalValue> TK_LIT_FALSE
%token<LexicalValue> TK_LIT_TRUE
%token<LexicalValue> '-' '!' '*' '/' '%' '+' '<' '>' '{' '}' '(' ')' '=' ',' ';'
%token<LexicalValue> TK_ERRO

%type<Node> program
%type<Node> elements_list
%type<Node> type
%type<Node> literal
%type<Node> global_variables
%type<Node> identifiers_list
%type<Node> functions
%type<Node> header
%type<Node> body
%type<Node> arguments
%type<Node> parameters_list
%type<Node> parameter
%type<Node> command_block
%type<Node> simple_command_list
%type<Node> command
%type<Node> variable_declaration
%type<Node> attribution_command
%type<Node> function_call
%type<Node> expression_list
%type<Node> return_command
%type<Node> flow_control_command
%type<Node> expression
%type<Node> expression_grade_eight
%type<Node> expression_grade_seven
%type<Node> expression_grade_six
%type<Node> expression_grade_five
%type<Node> expression_grade_four
%type<Node> expression_grade_three
%type<Node> expression_grade_two
%type<Node> expression_grade_one

%%

// ======================== PROGRAMA ========================
program: elements_list;
program: ;

elements_list: elements_list global_variables;
elements_list: elements_list functions;
elements_list: global_variables;
elements_list: functions;

// ======================== TIPOS ========================
type: TK_PR_INT | TK_PR_FLOAT | TK_PR_BOOL;

// ======================== LITERIAS ========================
literal: TK_LIT_INT | TK_LIT_FLOAT | TK_LIT_FALSE | TK_LIT_TRUE;

// ======================== VARIÁVEIS GLOBAIS ========================
global_variables: type identifiers_list ';';
identifiers_list: TK_IDENTIFICADOR | identifiers_list ',' TK_IDENTIFICADOR;

// ======================== FUNÇÕES ========================
functions: header body;
header: arguments TK_OC_GE type '!' TK_IDENTIFICADOR;
body: command_block;

// Lista de parâmetros
arguments: '(' ')' | '(' parameters_list ')';
parameters_list: parameters_list ',' parameter | parameter;
parameter: type TK_IDENTIFICADOR;

// ======================== BLOCO DE COMANDO ========================
command_block: '{' '}' | '{' simple_command_list '}';
simple_command_list: command | simple_command_list command;

// ======================== COMANDOS ========================
command: command_block ';';
command: variable_declaration ';';
command: attribution_command ';';
command: function_call ';';
command: return_command ';';
command: flow_control_command ';';

// Declaração de variável
variable_declaration: type identifiers_list;

// Atribuição
attribution_command: TK_IDENTIFICADOR '=' expression;

// Chamada de função
function_call: TK_IDENTIFICADOR '(' ')' | TK_IDENTIFICADOR '(' expression_list ')';
expression_list: expression | expression_list ',' expression;

// Comando de retorno
return_command: TK_PR_RETURN expression;

// Comando de controle de fluxo
flow_control_command: TK_PR_IF '(' expression ')' command_block; 
flow_control_command: TK_PR_IF '(' expression ')' command_block TK_PR_ELSE command_block;
flow_control_command: TK_PR_WHILE '(' expression ')' command_block;

// ======================== EXPRESSÕES ========================
expression: expression_grade_eight;

expression_grade_eight: expression_grade_eight TK_OC_OR expression_grade_seven;
expression_grade_eight: expression_grade_seven;

expression_grade_seven: expression_grade_seven TK_OC_AND expression_grade_six;
expression_grade_seven: expression_grade_six;

expression_grade_six: expression_grade_six TK_OC_EQ expression_grade_five;
expression_grade_six: expression_grade_six TK_OC_NE expression_grade_five;
expression_grade_six: expression_grade_five;

expression_grade_five: expression_grade_five '<' expression_grade_four;
expression_grade_five: expression_grade_five '>' expression_grade_four;
expression_grade_five: expression_grade_five TK_OC_LE expression_grade_four;
expression_grade_five: expression_grade_five TK_OC_GE expression_grade_four;
expression_grade_five: expression_grade_four;

expression_grade_four: expression_grade_four '+' expression_grade_three;
expression_grade_four: expression_grade_four '-' expression_grade_three;
expression_grade_four: expression_grade_three;

expression_grade_three: expression_grade_three '*' expression_grade_two;
expression_grade_three: expression_grade_three '/' expression_grade_two;
expression_grade_three: expression_grade_three '%' expression_grade_two;
expression_grade_three: expression_grade_two;

expression_grade_two: '-' expression_grade_one;
expression_grade_two: '!' expression_grade_one;
expression_grade_two: expression_grade_one;

expression_grade_one: TK_IDENTIFICADOR;
expression_grade_one: literal;
expression_grade_one: function_call;
expression_grade_one: '(' expression ')';

%%

void yyerror(cons char *message)
{
    printf("Erro sintático [%s] na linha %d\n", message, get_line_number());
    return;
}