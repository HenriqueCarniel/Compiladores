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
program: elements_list
{
    $$ = $1;
    arvore = $$;
};

program: 
{
    $$ = NULL;
    arvore = NULL;
};



elements_list: functions elements_list
{
    $$ = $1;
    addChild($$, $2);
};

elements_list: global_variables elements_list
{
    $$ = $2;
};

elements_list: functions
{
    $$ = $1;
};


elements_list: global_variables
{
    $$ = NULL;
};



// ======================== TIPOS ========================
type: TK_PR_INT
{
    $$ = NULL;
    freeLexicalValue($1);
};

type: TK_PR_FLOAT
{
    $$ = NULL;
    freeLexicalValue($1);
};

type: TK_PR_BOOL
{
    $$ = NULL;
    freeLexicalValue($1);
};



// ======================== LITERIAS ========================
literal: TK_LIT_INT
{
    $$ = createNode($1, DATA_TYPE_INT);
};

literal: TK_LIT_FLOAT
{
    $$ = createNode($1, DATA_TYPE_FLOAT);
};

literal: TK_LIT_FALSE
{
    $$ = createNode($1, DATA_TYPE_BOOL);
};

literal: TK_LIT_TRUE
{
    $$ = createNode($1, DATA_TYPE_BOOL);
};



// ======================== VARIÁVEIS GLOBAIS ========================
global_variables: type identifiers_list ';'
{
    $$ = NULL;
    removeNode($2);
    freeLexicalValue($3);
};

identifiers_list: TK_IDENTIFICADOR
{
    $$ = NULL;
    freeLexicalValue($1);
};

identifiers_list: TK_IDENTIFICADOR ',' identifiers_list
{
    $$ = NULL;
    freeLexicalValue($1);
    freeLexicalValue($2);
};



// ======================== FUNÇÕES ========================
functions: header body
{
    $$ = $1;
    addChild($$, $2);
};

header: arguments TK_OC_GE type '!' TK_IDENTIFICADOR
{
    $$ = createNode($5, DATA_TYPE_PLACEHOLDER);
    freeLexicalValue($2);
    freeLexicalValue($4);
};

body: command_block
{
    $$ = $1;
};



// Lista de parâmetros
arguments: '(' ')'
{
    $$ = NULL;
    freeLexicalValue($1);
    freeLexicalValue($2);
};

arguments: '(' parameters_list ')'
{
    $$ = NULL;
    freeLexicalValue($1);
    freeLexicalValue($3);
};

parameters_list: type TK_IDENTIFICADOR
{
    $$ = NULL;
    freeLexicalValue($2);
};

parameters_list: type TK_IDENTIFICADOR ',' parameters_list
{
    $$ = NULL;
    freeLexicalValue($2);
    freeLexicalValue($3);
};



// ======================== BLOCO DE COMANDO ========================
command_block: '{' '}'
{
    $$ = NULL;
    freeLexicalValue($1);
    freeLexicalValue($2);
};

command_block: '{' simple_command_list '}'
{
    $$ = $2;
    freeLexicalValue($1);
    freeLexicalValue($3);
};

simple_command_list: command
{
    $$ = $1;
};

simple_command_list: command simple_command_list 
{
    if ($1)
    {
        $$ = $1;
        addChild($$, $2);
    }
    else
    {
        $$ = $2;
    }
};



// ======================== COMANDOS ========================
command: command_block ';'
{
    $$ = $1;
    freeLexicalValue($2);
};

command: variable_declaration ';'
{
    $$ = $1;
    freeLexicalValue($2);
};

command: attribution_command ';'
{
    $$ = $1;
    freeLexicalValue($2);
};

command: function_call ';'
{
    $$ = $1;
    freeLexicalValue($2);
};

command: return_command ';'
{
    $$ = $1;
    freeLexicalValue($2);
};

command: flow_control_command ';'
{
    $$ = $1;
    freeLexicalValue($2);
};



// Declaração de variável ///////////////////////////////// VER ESSE INDENTIFIERS LIST
variable_declaration: type identifiers_list
{
    $$ = $2;
};



// Atribuição
attribution_command: TK_IDENTIFICADOR '=' expression
{
    $$ = createNode($2, DATA_TYPE_PLACEHOLDER);
    addChild($$, createNode($1, DATA_TYPE_PLACEHOLDER));
    addChild($$, $3);
};



// Chamada de função
function_call: TK_IDENTIFICADOR '(' ')'
{
    $$ = createNodeToFunctionCall($1, DATA_TYPE_PLACEHOLDER);
    freeLexicalValue($2);
    freeLexicalValue($3);
};

function_call: TK_IDENTIFICADOR '(' expression_list ')'
{
    $$ = createNodeToFunctionCall($1, DATA_TYPE_PLACEHOLDER);
    addChild($$, $3);
    freeLexicalValue($2);
    freeLexicalValue($4);
};

expression_list: expression
{
    $$ = $1;
};

expression_list: expression ',' expression_list
{
    $$ = $1;
    addChild($$, $3);
    freeLexicalValue($2);
};



// Comando de retorno
return_command: TK_PR_RETURN expression
{
    $$ = createNode($1, DATA_TYPE_PLACEHOLDER);
    addChild($$, $2);
};



// Comando de controle de fluxo
flow_control_command: TK_PR_IF '(' expression ')' command_block
{
    $$ = createNode($1, DATA_TYPE_PLACEHOLDER);
    addChild($$, $3);
    addChild($$, $5);
    freeLexicalValue($2);
    freeLexicalValue($4);
}; 

flow_control_command: TK_PR_IF '(' expression ')' command_block TK_PR_ELSE command_block
{
    $$ = createNode($1, DATA_TYPE_PLACEHOLDER);
    addChild($$, $3);
    addChild($$, $5);
    addChild($$, $7);
    freeLexicalValue($2);
    freeLexicalValue($4);
    freeLexicalValue($6);
};

flow_control_command: TK_PR_WHILE '(' expression ')' command_block
{
    $$ = createNode($1, DATA_TYPE_PLACEHOLDER);
    addChild($$, $3);
    addChild($$, $5);
    freeLexicalValue($2);
    freeLexicalValue($4);
};



// ======================== EXPRESSÕES ========================
expression: expression_grade_eight
{
    $$ = $1;
};



expression_grade_eight: expression_grade_eight TK_OC_OR expression_grade_seven
{
    $$ = createNode($2, DATA_TYPE_PLACEHOLDER);
    addChild($$, $1);
    addChild($$, $3);
};

expression_grade_eight: expression_grade_seven
{
    $$ = $1;
};



expression_grade_seven: expression_grade_seven TK_OC_AND expression_grade_six
{
    $$ = createNode($2, DATA_TYPE_PLACEHOLDER);
    addChild($$, $1);
    addChild($$, $3);
};

expression_grade_seven: expression_grade_six
{
    $$ = $1;
};



expression_grade_six: expression_grade_six TK_OC_EQ expression_grade_five
{
    $$ = createNode($2, DATA_TYPE_PLACEHOLDER);
    addChild($$, $1);
    addChild($$, $3);
};

expression_grade_six: expression_grade_six TK_OC_NE expression_grade_five
{
    $$ = createNode($2, DATA_TYPE_PLACEHOLDER);
    addChild($$, $1);
    addChild($$, $3);
};

expression_grade_six: expression_grade_five
{
    $$ = $1;
};



expression_grade_five: expression_grade_five '<' expression_grade_four
{
    $$ = createNode($2, DATA_TYPE_PLACEHOLDER);
    addChild($$, $1);
    addChild($$, $3);
};

expression_grade_five: expression_grade_five '>' expression_grade_four
{
    $$ = createNode($2, DATA_TYPE_PLACEHOLDER);
    addChild($$, $1);
    addChild($$, $3);
};

expression_grade_five: expression_grade_five TK_OC_LE expression_grade_four
{
    $$ = createNode($2, DATA_TYPE_PLACEHOLDER);
    addChild($$, $1);
    addChild($$, $3);
};

expression_grade_five: expression_grade_five TK_OC_GE expression_grade_four
{
    $$ = createNode($2, DATA_TYPE_PLACEHOLDER);
    addChild($$, $1);
    addChild($$, $3);
};

expression_grade_five: expression_grade_four
{
    $$ = $1;
};



expression_grade_four: expression_grade_four '+' expression_grade_three
{
    $$ = createNode($2, DATA_TYPE_PLACEHOLDER);
    addChild($$, $1);
    addChild($$, $3);
};

expression_grade_four: expression_grade_four '-' expression_grade_three
{
    $$ = createNode($2, DATA_TYPE_PLACEHOLDER);
    addChild($$, $1);
    addChild($$, $3);
};

expression_grade_four: expression_grade_three
{
    $$ = $1;
};



expression_grade_three: expression_grade_three '*' expression_grade_two
{
    $$ = createNode($2, DATA_TYPE_PLACEHOLDER);
    addChild($$, $1);
    addChild($$, $3);
};

expression_grade_three: expression_grade_three '/' expression_grade_two
{
    $$ = createNode($2, DATA_TYPE_PLACEHOLDER);
    addChild($$, $1);
    addChild($$, $3);
};

expression_grade_three: expression_grade_three '%' expression_grade_two
{
    $$ = createNode($2, DATA_TYPE_PLACEHOLDER);
    addChild($$, $1);
    addChild($$, $3);
};

expression_grade_three: expression_grade_two
{
    $$ = $1;
};



expression_grade_two: '-' expression_grade_one
{
    $$ = createNode($1, DATA_TYPE_PLACEHOLDER);
    addChild($$, $2);
};

expression_grade_two: '!' expression_grade_one
{
    $$ = createNode($1, DATA_TYPE_PLACEHOLDER);
    addChild($$, $2);
};

expression_grade_two: expression_grade_one
{
    $$ = $1;
};



expression_grade_one: TK_IDENTIFICADOR
{
    $$ = createNode($1, DATA_TYPE_PLACEHOLDER);
};

expression_grade_one: literal
{
    $$ = $1;
};

expression_grade_one: function_call
{
    $$ = $1;
};

expression_grade_one: '(' expression ')'
{
    $$ = $2;
    freeLexicalValue($1);
    freeLexicalValue($3);
};

%%

void yyerror(const char *message)
{
    printf("Erro sintático [%s] na linha %d\n", message, get_line_number());
    return;
}