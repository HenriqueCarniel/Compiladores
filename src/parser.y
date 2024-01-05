/* ======= GRUPO A =======
Henrique Carniel da Silva 
Jose Henrique Lima Marques */

%{
#include <stdio.h>
#include "tree.h"
#include "lexical_value.h"
#include "types.h"

int yylex(void);
void yyerror (char const *mensagem);
int get_line_number();
extern void *arvore;

// O tipo atualmente declarado
DataType declaredType = DATA_TYPE_UNDECLARED;

%}

%code requires
{
    #include "tree.h"
    #include "lexical_value.h"
    #include "symbol_table.h"
}

%union
{
    char* ASTLabel;
    LexicalValue LexicalValue;
    struct Node* Node;
    DataType DataType;
    SymbolNature SymbolNature;
}

%define parse.error verbose

%token TK_ERRO

%token TK_PR_INT
%token TK_PR_FLOAT
%token TK_PR_BOOL
%token '{' '}' '(' ')' ',' ';' TK_PR_ELSE

%token<ASTLabel> '-' '!' '*' '/' '%' '+' '<' '>' '='
%token<ASTLabel> TK_PR_IF
%token<ASTLabel> TK_PR_WHILE
%token<ASTLabel> TK_PR_RETURN
%token<ASTLabel> TK_OC_LE
%token<ASTLabel> TK_OC_GE
%token<ASTLabel> TK_OC_EQ
%token<ASTLabel> TK_OC_NE
%token<ASTLabel> TK_OC_AND
%token<ASTLabel> TK_OC_OR

%token<LexicalValue> TK_IDENTIFICADOR
%token<LexicalValue> TK_LIT_INT
%token<LexicalValue> TK_LIT_FLOAT
%token<LexicalValue> TK_LIT_FALSE
%token<LexicalValue> TK_LIT_TRUE

%type<Node> program
%type<Node> elements_list
%type<DataType> type
%type<Node> literal
%type<Node> global_variables
%type<Node> identifiers_list
%type<Node> functions
%type<Node> header
%type<Node> body
%type<Node> function_arguments
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

program: %empty 
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
// Tipos vão ser reduzidos antes dos identificadores, conforme regras

type: TK_PR_INT
{
    declaredType = DATA_TYPE_INT;
    $$ = DATA_TYPE_INT;
};

type: TK_PR_FLOAT
{
    declaredType = DATA_TYPE_FLOAT;
    $$ = DATA_TYPE_FLOAT;
};

type: TK_PR_BOOL
{
    declaredType = DATA_TYPE_BOOL;
    $$ = DATA_TYPE_BOOL;
};



// ======================== LITERAIS ========================
literal: TK_LIT_INT
{
    $$ = createNodeFromLexicalValue($1, DATA_TYPE_INT);
    SymbolTableEntryValue value = createSymbolTableEntryValue(
        SYMBOL_NATURE_LITERAL,
        DATA_TYPE_INT,
        $1
    );
    addSymbolValueToGlobalTableStack(value);

};

literal: TK_LIT_FLOAT
{
    $$ = createNodeFromLexicalValue($1, DATA_TYPE_FLOAT);
    SymbolTableEntryValue value = createSymbolTableEntryValue(
        SYMBOL_NATURE_LITERAL,
        DATA_TYPE_FLOAT,
        $1
    );
    addSymbolValueToGlobalTableStack(value);
};

literal: TK_LIT_FALSE
{
    $$ = createNodeFromLexicalValue($1, DATA_TYPE_BOOL);
    SymbolTableEntryValue value = createSymbolTableEntryValue(
        SYMBOL_NATURE_LITERAL,
        DATA_TYPE_BOOL,
        $1
    );
    addSymbolValueToGlobalTableStack(value);
};

literal: TK_LIT_TRUE
{
    $$ = createNodeFromLexicalValue($1, DATA_TYPE_BOOL);
    SymbolTableEntryValue value = createSymbolTableEntryValue(
        SYMBOL_NATURE_LITERAL,
        DATA_TYPE_BOOL,
        $1
    );
    addSymbolValueToGlobalTableStack(value);
};



// ======================== VARIÁVEIS GLOBAIS ========================
/*

    Exemplo de redução:
    T=type
    IL=identifiers_list

    EMPILHA INT
    REDUZ T->INT
    EMPILHA X1
    EMPILHA ,
    EMPILHA X2
    EMPILHA ,
    EMPILHA X3
    REDUZ IL->X3
    REDUZ IL->X2, IL
    REDUZ IL->X1, IL

                                |   int x1, x2, x3;
    1ª redução: T->int          |   T x1, x2, x3
    2ª redução: IL->x3          |   T x1, x2, IL
    3ª redução: IL->x2,IL       |   T x1, IL
    4ª redução: IL->x1,IL       |   T IL
    5ª redução: GV-> T IL       |   GV

    Logo, tipo é reduzido primeiro

*/


global_variables: type identifiers_list ';'
{
    $$ = NULL;
    removeNode($2);
    
    // Não tem mais um tipo sendo declarado
    declaredType = DATA_TYPE_UNDECLARED;
    };

identifiers_list: TK_IDENTIFICADOR
{
    $$ = NULL;
    // Adiciona identificador à tabela de tipos
    SymbolTableEntryValue value = createSymbolTableEntryValue(
        SYMBOL_NATURE_IDENTIFIER,
        declaredType,
        $1
    );
    addSymbolValueToGlobalTableStack(value);
    
    };

identifiers_list: TK_IDENTIFICADOR ',' identifiers_list
{
    $$ = NULL;
    // Adiciona identificador à tabela de tipos
    SymbolTableEntryValue value = createSymbolTableEntryValue(
        SYMBOL_NATURE_IDENTIFIER,
        declaredType,
        $1
    );
    addSymbolValueToGlobalTableStack(value);

    };



// ======================== FUNÇÕES ========================
functions: header body
{
    $$ = $1;
    addChild($$, $2);

    // Após a redução de header e body, desempilhamos
    // o contexto criado para os argumentos, com a pilha
    // tendo somente o frame global
    popGlobalStack();

};

header: function_arguments TK_OC_GE type '!' TK_IDENTIFICADOR
{   
    // Adiciona identificador à tabela de tipos
    SymbolTableEntryValue value = createSymbolTableEntryValue(
        SYMBOL_NATURE_FUNCTION,
        declaredType,
        $5
    );
    // Porém, devido ao fato de estarmos no escopo dos parâmetros,
    // o identificador deve ir na tabela abaixo (global)
    addSymbolValueToBelowGlobalTableStack(value);

    $$ = createNodeFromLexicalValue($5, $3);

};

body: command_block
{   
    $$ = $1;
};



// Lista de parâmetros

// O início de uma lista de parâmetros de uma função
// leva a criação de um novo escopo onde estarão os argumentos
function_argument_begin: '('
{
    addTableToGlobalStack(createSymbolTable());
}

function_arguments: function_argument_begin ')'
{
    $$ = NULL;
};

function_arguments: function_argument_begin parameters_list ')'
{
    $$ = NULL;
};

parameters_list: type TK_IDENTIFICADOR
{
    $$ = NULL;

    // Adiciona identificador à tabela de tipos
    SymbolTableEntryValue value = createSymbolTableEntryValue(
        SYMBOL_NATURE_IDENTIFIER,
        declaredType,
        $2
    );
    addSymbolValueToGlobalTableStack(value);


    freeLexicalValue($2);
};

parameters_list: type TK_IDENTIFICADOR ',' parameters_list
{
    $$ = NULL;

    // Adiciona identificador à tabela de tipos
    SymbolTableEntryValue value = createSymbolTableEntryValue(
        SYMBOL_NATURE_IDENTIFIER,
        declaredType,
        $2
    );
    addSymbolValueToGlobalTableStack(value);

    freeLexicalValue($2);
};



// ======================== BLOCO DE COMANDO ========================
command_block_begin: '{'
{
    addTableToGlobalStack(createSymbolTable());
};

command_block_end: '}'
{
    popGlobalStack();
};

command_block: command_block_begin command_block_end
{
    $$ = NULL;
};

command_block: command_block_begin simple_command_list command_block_end
{
    $$ = $2;
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
};

command: variable_declaration ';'
{
    $$ = $1;
};

command: attribution_command ';'
{
    $$ = $1;
};

command: function_call ';'
{
    $$ = $1;
};

command: return_command ';'
{
    $$ = $1;
};

command: flow_control_command ';'
{
    $$ = $1;
};



// Declaração de variável ///////////////////////////////// VER ESSE INDENTIFIERS LIST
variable_declaration: type identifiers_list
{
    $$ = $2;
};



// Atribuição
attribution_command: TK_IDENTIFICADOR '=' expression
{
    DataType type =  inferTypeFromIdentifier($1);
    checkIdentifierIsVariable($1);

    $$ = createNodeFromLabel($2, type);
    addChild($$, createNodeFromLexicalValue($1, type));
    addChild($$, $3);
};



// Chamada de função
function_call: TK_IDENTIFICADOR '(' ')'
{
    DataType type =  inferTypeFromIdentifier($1);
    checkIdentifierIsFunction($1);

    $$ = createNodeToFunctionCall($1, type);
};

function_call: TK_IDENTIFICADOR '(' expression_list ')'
{
    DataType type =  inferTypeFromIdentifier($1);
    checkIdentifierIsFunction($1);

    $$ = createNodeToFunctionCall($1, type);
    addChild($$, $3);
};

expression_list: expression
{
    $$ = $1;
};

expression_list: expression ',' expression_list
{
    $$ = $1;
    addChild($$, $3);
};



// Comando de retorno
return_command: TK_PR_RETURN expression
{
    $$ = createNodeFromLabel($1, inferTypeFromNode($2));
    addChild($$, $2);
};



// Comando de controle de fluxo
flow_control_command: TK_PR_IF '(' expression ')' '{' simple_command_list '}'
{
    $$ = createNodeFromLabel($1, inferTypeFromNode($3));
    addChild($$, $3);
    addChild($$, $6);
}; 

flow_control_command: TK_PR_IF '(' expression ')' '{' simple_command_list '}' TK_PR_ELSE '{' simple_command_list '}'
{
    $$ = createNodeFromLabel($1, inferTypeFromNode($3));
    addChild($$, $3);
    addChild($$, $6);
    addChild($$, $10);
};

flow_control_command: TK_PR_WHILE '(' expression ')' '{' simple_command_list '}'
{
    $$ = createNodeFromLabel($1, inferTypeFromNode($3));
    addChild($$, $3);
    addChild($$, $6);
};



// ======================== EXPRESSÕES ========================
expression: expression_grade_eight
{
    $$ = $1;
};



expression_grade_eight: expression_grade_eight TK_OC_OR expression_grade_seven
{
    $$ = createNodeFromLabel($2, inferTypeFromNodes($1, $3));
    addChild($$, $1);
    addChild($$, $3);
};

expression_grade_eight: expression_grade_seven
{
    $$ = $1;
};



expression_grade_seven: expression_grade_seven TK_OC_AND expression_grade_six
{
    $$ = createNodeFromLabel($2, inferTypeFromNodes($1, $3));
    addChild($$, $1);
    addChild($$, $3);
};

expression_grade_seven: expression_grade_six
{
    $$ = $1;
};



expression_grade_six: expression_grade_six TK_OC_EQ expression_grade_five
{
    $$ = createNodeFromLabel($2, inferTypeFromNodes($1, $3));
    addChild($$, $1);
    addChild($$, $3);
};

expression_grade_six: expression_grade_six TK_OC_NE expression_grade_five
{
    $$ = createNodeFromLabel($2, inferTypeFromNodes($1, $3));
    addChild($$, $1);
    addChild($$, $3);
};

expression_grade_six: expression_grade_five
{
    $$ = $1;
};



expression_grade_five: expression_grade_five '<' expression_grade_four
{
    $$ = createNodeFromLabel($2, inferTypeFromNodes($1, $3));
    addChild($$, $1);
    addChild($$, $3);
};

expression_grade_five: expression_grade_five '>' expression_grade_four
{
    $$ = createNodeFromLabel($2, inferTypeFromNodes($1, $3));
    addChild($$, $1);
    addChild($$, $3);
};

expression_grade_five: expression_grade_five TK_OC_LE expression_grade_four
{
    $$ = createNodeFromLabel($2, inferTypeFromNodes($1, $3));
    addChild($$, $1);
    addChild($$, $3);
};

expression_grade_five: expression_grade_five TK_OC_GE expression_grade_four
{
    $$ = createNodeFromLabel($2, inferTypeFromNodes($1, $3));
    addChild($$, $1);
    addChild($$, $3);
};

expression_grade_five: expression_grade_four
{
    $$ = $1;
};



expression_grade_four: expression_grade_four '+' expression_grade_three
{
    $$ = createNodeFromLabel($2, inferTypeFromNodes($1, $3));
    addChild($$, $1);
    addChild($$, $3);
};

expression_grade_four: expression_grade_four '-' expression_grade_three
{
    $$ = createNodeFromLabel($2, inferTypeFromNodes($1, $3));
    addChild($$, $1);
    addChild($$, $3);
};

expression_grade_four: expression_grade_three
{
    $$ = $1;
};



expression_grade_three: expression_grade_three '*' expression_grade_two
{
    $$ = createNodeFromLabel($2, inferTypeFromNodes($1, $3));
    addChild($$, $1);
    addChild($$, $3);
};

expression_grade_three: expression_grade_three '/' expression_grade_two
{
    $$ = createNodeFromLabel($2, inferTypeFromNodes($1, $3));
    addChild($$, $1);
    addChild($$, $3);
};

expression_grade_three: expression_grade_three '%' expression_grade_two
{
    $$ = createNodeFromLabel($2, inferTypeFromNodes($1, $3));
    addChild($$, $1);
    addChild($$, $3);
};

expression_grade_three: expression_grade_two
{
    $$ = $1;
};



expression_grade_two: '-' expression_grade_one
{
    $$ = createNodeFromLabel($1, inferTypeFromNode($2));
    addChild($$, $2);
};

expression_grade_two: '!' expression_grade_one
{
    $$ = createNodeFromLabel($1, inferTypeFromNode($2));
    addChild($$, $2);
};

expression_grade_two: expression_grade_one
{
    $$ = $1;
};



expression_grade_one: TK_IDENTIFICADOR
{
    // Procura pelo tipo do identificador
    DataType type = inferTypeFromIdentifier($1);
    checkIdentifierIsVariable($1);

    $$ = createNodeFromLexicalValue($1, type);
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
};

%%

void yyerror(const char *message)
{
    printf("Erro sintático [%s] na linha %d\n", message, get_line_number());
    return;
}