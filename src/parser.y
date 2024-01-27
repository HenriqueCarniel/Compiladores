/* ======= GRUPO A =======
Henrique Carniel da Silva 
Jose Henrique Lima Marques */

%{
#include <stdio.h>
#include "tree.h"
#include "lexical_value.h"
#include "types.h"
#include "iloc.h"

int yylex(void);
void yyerror (char const *mensagem);
int get_line_number();
extern Node *arvore;

// O tipo atualmente declarado
DataType declaredType = DATA_TYPE_UNDECLARED;

///////////////////////// ETAPA 5 /////////////////////////
int mainLabel = 0;
int mainPosition = 0;
int currentRFPoffset = 0;

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
%type<Node> command_block_flow_control_command
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

program: %empty 
{
    $$ = NULL;
    arvore = NULL;
};

program: elements_list
{
    $$ = $1;
    arvore = $$;

    // TODO: necessário implementar algo por aq?
};



elements_list: functions elements_list
{
    $$ = $1;
    addChild($$, $2);
    addIlocListToIlocList($$->operationList, $2->operationList);
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

    ///////////////////////// ETAPA 5 /////////////////////////
    IlocOperationList* operationList = createIlocOperationList();

    int c1 = atoi($1.label);
    int r1 = generateRegister();

    IlocOperation operation = generateOperation(OP_LOADI, c1, -1, r1, -1);
    addOperationToIlocList(operationList, operation);

    $$->outRegister = r1;
    $$->operationList = operationList;
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

global_variables: type identifiers_list ';'
{
    $$ = NULL;

    // TODO: comentei essa linha de baixo meio SUS
    //removeNode($2);
    
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


// TODO: implementar toda essa parte de funções
// ======================== FUNÇÕES ========================
functions: header body
{
    $$ = $1;
    addChild($$, $2);

    // Após a redução de header e body, desempilhamos
    // o contexto criado para os argumentos, com a pilha
    // tendo somente o frame global
    popGlobalStack();

    if ($2)
    {
        $$->operationList = $2->operationList;
    }
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

function_arguments: function_argument_begin ')'
{
    $$ = NULL;
};

function_arguments: function_argument_begin parameters_list ')'
{
    $$ = $2;
};

// O início de uma lista de parâmetros de uma função
// leva a criação de um novo escopo onde estarão os argumentos
function_argument_begin: '('
{
    addTableToGlobalStack(createSymbolTable());
}

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

    // TODO: atualizar $$->position

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

    // TODO: atualizar $$->position

    freeLexicalValue($2);
};



// ======================== BLOCO DE COMANDO ========================

command_block: command_block_begin command_block_end
{
    $$ = NULL;
};

command_block: command_block_begin simple_command_list command_block_end
{
    $$ = $2;
    // TODO: atualizar por aqui o $$->lastPosition
};

command_block_begin: '{'
{
    addTableToGlobalStack(createSymbolTable());
};

command_block_end: '}'
{
    //printf("Final stack state:\n");
    //printGlobalTableStack(100);
    //printf("\n\n");

    popGlobalStack();
};

// Isso foi feito pois os blocos de comandos de fluxo de controle não geram um novo escopo,
//de acordo com a especificação dada pelo professor
command_block_flow_control_command: '{' '}'
{
    $$ = NULL;
}

command_block_flow_control_command: '{' simple_command_list '}'
{
    $$ = $2;
}

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
        addIlocListToIlocList($1->operationList, $2->operationList);
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

    ///////////////////////// ETAPA 5 /////////////////////////
    IlocOperationList* operationList = createListFromOtherList($3->operationList);
    SymbolTableEntryValue symbol = getSymbolFromStackByKey($1.label);

    int address = symbol.position;
    int r1 = $3->outRegister;

    IlocOperation operation;
    
    if (symbol.isGlobal)
    {
        operation = generateOperation(OP_STOREAI_GLOBAL, r1, -1, address, -1);
    }
    else
    {
        operation = generateOperation(OP_STOREAI_LOCAL, r1, -1, address, -1);
    }

    addOperationToIlocList(operationList, operation);

    $$->operationList = operationList;
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

    $$->operationList = $3->operationList;
};

expression_list: expression
{
    $$ = $1;
};

expression_list: expression ',' expression_list
{
    $$ = $1;
    addChild($$, $3);

    IlocOperationList* operationList = joinOperationLists($1->operationList, $3->operationList);
    $$->operationList = operationList;
};



// Comando de retorno
return_command: TK_PR_RETURN expression
{
    $$ = createNodeFromLabel($1, inferTypeFromNode($2));
    addChild($$, $2);
};



// Comando de controle de fluxo
flow_control_command: TK_PR_IF '(' expression ')' command_block_flow_control_command
{
    $$ = createNodeFromLabel($1, inferTypeFromNode($3));
    addChild($$, $3);
    addChild($$, $5);

    int registerExpression = $3->outRegister;
    int registerFalse = generateRegister();
    int registerCmp = generateRegister();

    int labelTrue = generateLabel();
    int labelFalse = generateLabel();

    IlocOperationList* operationList = createListFromOtherList($3->operationList);

    // loadI 0 => registerFalse
    IlocOperation operationLoadFalse = generateOperation(OP_LOADI, 0, -1, registerFalse, -1);
    addOperationToIlocList(operationList, operationLoadFalse);

    // cmp_NE registerExpression, registerFalse -> registerCmp
    IlocOperation operationCmpFalse = generateOperation(OP_CMP_NE, registerExpression, registerFalse, registerCmp, -1);
    addOperationToIlocList(operationList, operationCmpFalse);

    // cbr registerCmp -> labelTrue, labelFalse
    IlocOperation operationCbr = generateOperation(OP_CBR, registerCmp, -1, labelTrue, labelFalse);
    addOperationToIlocList(operationList, operationCbr);

    // "labelTrue": nop
    IlocOperation operationNopTrue = generateNopOperation();
    operationNopTrue = addLabelToOperation(operationNopTrue, labelTrue);
    addOperationToIlocList(operationList, operationNopTrue);

    // -- CÓDIGO DO BLOCO DE COMANDOS --
    if ($5)
    {
        addIlocListToIlocList(operationList, $5->operationList);
    }

    // "labelFalse": nop
    IlocOperation operationNopFalse = generateNopOperation();
    operationNopFalse = addLabelToOperation(operationNopFalse, labelFalse);
    addOperationToIlocList(operationList, operationNopFalse);

    $$->operationList = operationList;
};

flow_control_command: TK_PR_IF '(' expression ')' command_block_flow_control_command TK_PR_ELSE command_block_flow_control_command
{
    $$ = createNodeFromLabel($1, inferTypeFromNode($3));
    addChild($$, $3);
    addChild($$, $5);
    addChild($$, $7);

    int registerExpression = $3->outRegister;
    int registerFalse = generateRegister();
    int registerCmp = generateRegister();

    int labelTrue = generateLabel();
    int labelFalse = generateLabel();
    int labelEnd = generateLabel();

    IlocOperationList* operationList = createListFromOtherList($3->operationList);

    // loadI 0 => registerFalse
    IlocOperation operationLoadFalse = generateOperation(OP_LOADI, 0, -1, registerFalse, -1);
    addOperationToIlocList(operationList, operationLoadFalse);

    // cmp_NE registerExpression, registerFalse -> registerCmp
    IlocOperation operationCmpFalse = generateOperation(OP_CMP_NE, registerExpression, registerFalse, registerCmp, -1);
    addOperationToIlocList(operationList, operationCmpFalse);

    // cbr registerCmp -> labelTrue, labelFalse
    IlocOperation operationCbr = generateOperation(OP_CBR, registerCmp, -1, labelTrue, labelFalse);
    addOperationToIlocList(operationList, operationCbr);

    // "labelTrue": nop
    IlocOperation operationNopTrue = generateNopOperation();
    operationNopTrue = addLabelToOperation(operationNopTrue, labelTrue);
    addOperationToIlocList(operationList, operationNopTrue);

    // -- CÓDIGO DO BLOCO DE COMANDOS VERDADEIRO --
    // jumpI -> labelEnd
    if ($5)
    {
        addIlocListToIlocList(operationList, $5->operationList);
    }
    IlocOperation operationJumpAfterCode = generateOperation(OP_JUMPI, labelEnd, -1, -1, -1);
    addOperationToIlocList(operationList, operationJumpAfterCode);

    // "labelFalse": nop
    IlocOperation operationNopFalse = generateNopOperation();
    operationNopFalse = addLabelToOperation(operationNopFalse, labelFalse);
    addOperationToIlocList(operationList, operationNopFalse);

    // -- CÓDIGO DO BLOCO DE COMANDOS FALSO --
    if ($7)
    {
        addIlocListToIlocList(operationList, $7->operationList);
    }    

    // "labelEnd": nop
    IlocOperation operationNopEnd = generateNopOperation();
    operationNopEnd = addLabelToOperation(operationNopEnd, labelEnd);
    addOperationToIlocList(operationList, operationNopEnd);

    $$->operationList = operationList;
};

flow_control_command: TK_PR_WHILE '(' expression ')' command_block_flow_control_command
{
    $$ = createNodeFromLabel($1, inferTypeFromNode($3));
    addChild($$, $3);
    addChild($$, $5);

    int registerExpression = $3->outRegister;
    int registerFalse = generateRegister();
    int registerCmp = generateRegister();

    int labelComparation = generateLabel();
    int labelTrue = generateLabel();
    int labelFalse = generateLabel();

    IlocOperationList* operationList = createIlocOperationList();

    // loadI 0 => registerFalse
    IlocOperation operationLoadFalse = generateOperation(OP_LOADI, 0, -1, registerFalse, -1);
    addOperationToIlocList(operationList, operationLoadFalse);

    // "labelComparation": nop
    IlocOperation operationNopComparation = generateNopOperation();
    operationNopComparation = addLabelToOperation(operationNopComparation, labelComparation);
    addOperationToIlocList(operationList, operationNopComparation);

    // -- GERA VALOR DO CONDICIONAL E SALVA EM registerExpression --
    addIlocListToIlocList(operationList, $3->operationList);

    // cmp_NE registerExpression, registerFalse -> registerCmp
    // cbr registerCmp -> labelTrue, labelFalse
    IlocOperation operationCmpFalse = generateOperation(OP_CMP_NE, registerExpression, registerFalse, registerCmp, -1);
    addOperationToIlocList(operationList, operationCmpFalse);
    IlocOperation operationCbr = generateOperation(OP_CBR, registerCmp, -1, labelTrue, labelFalse);
    addOperationToIlocList(operationList, operationCbr);
    
    // "labelTrue": nop
    IlocOperation operationNopTrue = generateNopOperation();
    operationNopTrue = addLabelToOperation(operationNopTrue, labelTrue);
    addOperationToIlocList(operationList, operationNopTrue);

    // -- CÓDIGO DO BLOCO DE COMANDOS --
    if ($5)
    {
        addIlocListToIlocList(operationList, $5->operationList);
    }
    
    // jumpI -> labelComparation
    IlocOperation operationJumpAfterCode = generateOperation(OP_JUMPI, labelComparation, -1, -1, -1);
    addOperationToIlocList(operationList, operationJumpAfterCode);

    // "labelFalse": nop
    IlocOperation operationNopFalse = generateNopOperation();
    operationNopFalse = addLabelToOperation(operationNopFalse, labelFalse);
    addOperationToIlocList(operationList, operationNopFalse);

    $$->operationList = operationList;
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

    ///////////////////////// ETAPA 5 /////////////////////////
    IlocOperationList* operationList = joinOperationLists($1->operationList, $3->operationList);

    int r1 = $1->outRegister;
    int r2 = $3->outRegister;
    int r3 = generateRegister();

    IlocOperation operation = generateOperation(OP_OR, r1, r2, r3, -1);
    addOperationToIlocList(operationList, operation);

    $$->outRegister = r3;
    $$->operationList = operationList;
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

    ///////////////////////// ETAPA 5 /////////////////////////
    IlocOperationList* operationList = joinOperationLists($1->operationList, $3->operationList);

    int r1 = $1->outRegister;
    int r2 = $3->outRegister;
    int r3 = generateRegister();

    IlocOperation operation = generateOperation(OP_AND, r1, r2, r3, -1);
    addOperationToIlocList(operationList, operation);

    $$->outRegister = r3;
    $$->operationList = operationList;
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

    ///////////////////////// ETAPA 5 /////////////////////////
    IlocOperationList* operationList = joinOperationLists($1->operationList, $3->operationList);

    int r1 = $1->outRegister;
    int r2 = $3->outRegister;
    int r3 = generateRegister();
    int r4 = generateRegister();
    int labelTrue = generateLabel();
    int labelFalse = generateLabel();
    int labelEnd = generateLabel();

    IlocOperation operationCmpEQ = generateOperation(OP_CMP_EQ, r1, r2, r3, -1);
    addOperationToIlocList(operationList, operationCmpEQ);

    IlocOperation operationCbr = generateOperation(OP_CBR, r3, -1, labelTrue, labelFalse);
    addOperationToIlocList(operationList, operationCbr);

    // IF TRUE
    IlocOperation operationTrue = generateOperation(OP_LOADI, 1, -1, r4, -1);
    operationTrue = addLabelToOperation(operationTrue, labelTrue);
    IlocOperation operationJumpTrue = generateOperation(OP_JUMPI, labelEnd, -1, -1, -1);
    addOperationToIlocList(operationList, operationTrue);
    addOperationToIlocList(operationList, operationJumpTrue);

    // ELSE
    IlocOperation operationFalse = generateOperation(OP_LOADI, 0, -1, r4, -1);
    operationFalse = addLabelToOperation(operationFalse, labelFalse);
    addOperationToIlocList(operationList, operationFalse);

    // NOP
    IlocOperation operationNop = generateNopOperation();
    operationNop = addLabelToOperation(operationNop, labelEnd);
    addOperationToIlocList(operationList, operationNop);

    $$->outRegister = r4;
    $$->operationList = operationList;
};

expression_grade_six: expression_grade_six TK_OC_NE expression_grade_five
{
    $$ = createNodeFromLabel($2, inferTypeFromNodes($1, $3));
    addChild($$, $1);
    addChild($$, $3);

    ///////////////////////// ETAPA 5 /////////////////////////
    IlocOperationList* operationList = joinOperationLists($1->operationList, $3->operationList);

    int r1 = $1->outRegister;
    int r2 = $3->outRegister;
    int r3 = generateRegister();
    int r4 = generateRegister();
    int labelTrue = generateLabel();
    int labelFalse = generateLabel();
    int labelEnd = generateLabel();

    IlocOperation operationCmpNE = generateOperation(OP_CMP_NE, r1, r2, r3, -1);
    addOperationToIlocList(operationList, operationCmpNE);

    IlocOperation operationCbr = generateOperation(OP_CBR, r3, -1, labelTrue, labelFalse);
    addOperationToIlocList(operationList, operationCbr);

    // IF TRUE
    IlocOperation operationTrue = generateOperation(OP_LOADI, 1, -1, r4, -1);
    operationTrue = addLabelToOperation(operationTrue, labelTrue);
    IlocOperation operationJumpTrue = generateOperation(OP_JUMPI, labelEnd, -1, -1, -1);
    addOperationToIlocList(operationList, operationTrue);
    addOperationToIlocList(operationList, operationJumpTrue);

    // ELSE
    IlocOperation operationFalse = generateOperation(OP_LOADI, 0, -1, r4, -1);
    operationFalse = addLabelToOperation(operationFalse, labelFalse);
    addOperationToIlocList(operationList, operationFalse);

    // NOP
    IlocOperation operationNop = generateNopOperation();
    operationNop = addLabelToOperation(operationNop, labelEnd);
    addOperationToIlocList(operationList, operationNop);

    $$->outRegister = r4;
    $$->operationList = operationList;
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

    ///////////////////////// ETAPA 5 /////////////////////////
    IlocOperationList* operationList = joinOperationLists($1->operationList, $3->operationList);

    int r1 = $1->outRegister;
    int r2 = $3->outRegister;
    int r3 = generateRegister();
    int r4 = generateRegister();
    int labelTrue = generateLabel();
    int labelFalse = generateLabel();
    int labelEnd = generateLabel();

    IlocOperation operationCmpLT = generateOperation(OP_CMP_LT, r1, r2, r3, -1);
    addOperationToIlocList(operationList, operationCmpLT);

    IlocOperation operationCbr = generateOperation(OP_CBR, r3, -1, labelTrue, labelFalse);
    addOperationToIlocList(operationList, operationCbr);

    // IF TRUE
    IlocOperation operationTrue = generateOperation(OP_LOADI, 1, -1, r4, -1);
    operationTrue = addLabelToOperation(operationTrue, labelTrue);
    IlocOperation operationJumpTrue = generateOperation(OP_JUMPI, labelEnd, -1, -1, -1);
    addOperationToIlocList(operationList, operationTrue);
    addOperationToIlocList(operationList, operationJumpTrue);

    // ELSE
    IlocOperation operationFalse = generateOperation(OP_LOADI, 0, -1, r4, -1);
    operationFalse = addLabelToOperation(operationFalse, labelFalse);
    addOperationToIlocList(operationList, operationFalse);

    // NOP
    IlocOperation operationNop = generateNopOperation();
    operationNop = addLabelToOperation(operationNop, labelEnd);
    addOperationToIlocList(operationList, operationNop);

    $$->outRegister = r4;
    $$->operationList = operationList;
};

expression_grade_five: expression_grade_five '>' expression_grade_four
{
    $$ = createNodeFromLabel($2, inferTypeFromNodes($1, $3));
    addChild($$, $1);
    addChild($$, $3);

    ///////////////////////// ETAPA 5 /////////////////////////
    IlocOperationList* operationList = joinOperationLists($1->operationList, $3->operationList);

    int r1 = $1->outRegister;
    int r2 = $3->outRegister;
    int r3 = generateRegister();
    int r4 = generateRegister();
    int labelTrue = generateLabel();
    int labelFalse = generateLabel();
    int labelEnd = generateLabel();

    IlocOperation operationCmpGT = generateOperation(OP_CMP_GT, r1, r2, r3, -1);
    addOperationToIlocList(operationList, operationCmpGT);

    IlocOperation operationCbr = generateOperation(OP_CBR, r3, -1, labelTrue, labelFalse);
    addOperationToIlocList(operationList, operationCbr);

    // IF TRUE
    IlocOperation operationTrue = generateOperation(OP_LOADI, 1, -1, r4, -1);
    operationTrue = addLabelToOperation(operationTrue, labelTrue);
    IlocOperation operationJumpTrue = generateOperation(OP_JUMPI, labelEnd, -1, -1, -1);
    addOperationToIlocList(operationList, operationTrue);
    addOperationToIlocList(operationList, operationJumpTrue);

    // ELSE
    IlocOperation operationFalse = generateOperation(OP_LOADI, 0, -1, r4, -1);
    operationFalse = addLabelToOperation(operationFalse, labelFalse);
    addOperationToIlocList(operationList, operationFalse);

    // NOP
    IlocOperation operationNop = generateNopOperation();
    operationNop = addLabelToOperation(operationNop, labelEnd);
    addOperationToIlocList(operationList, operationNop);

    $$->outRegister = r4;
    $$->operationList = operationList;
};

expression_grade_five: expression_grade_five TK_OC_LE expression_grade_four
{
    $$ = createNodeFromLabel($2, inferTypeFromNodes($1, $3));
    addChild($$, $1);
    addChild($$, $3);

    ///////////////////////// ETAPA 5 /////////////////////////
    IlocOperationList* operationList = joinOperationLists($1->operationList, $3->operationList);

    int r1 = $1->outRegister;
    int r2 = $3->outRegister;
    int r3 = generateRegister();
    int r4 = generateRegister();
    int labelTrue = generateLabel();
    int labelFalse = generateLabel();
    int labelEnd = generateLabel();

    IlocOperation operationCmpLE = generateOperation(OP_CMP_LE, r1, r2, r3, -1);
    addOperationToIlocList(operationList, operationCmpLE);

    IlocOperation operationCbr = generateOperation(OP_CBR, r3, -1, labelTrue, labelFalse);
    addOperationToIlocList(operationList, operationCbr);

    // IF TRUE
    IlocOperation operationTrue = generateOperation(OP_LOADI, 1, -1, r4, -1);
    operationTrue = addLabelToOperation(operationTrue, labelTrue);
    IlocOperation operationJumpTrue = generateOperation(OP_JUMPI, labelEnd, -1, -1, -1);
    addOperationToIlocList(operationList, operationTrue);
    addOperationToIlocList(operationList, operationJumpTrue);

    // ELSE
    IlocOperation operationFalse = generateOperation(OP_LOADI, 0, -1, r4, -1);
    operationFalse = addLabelToOperation(operationFalse, labelFalse);
    addOperationToIlocList(operationList, operationFalse);

    // NOP
    IlocOperation operationNop = generateNopOperation();
    operationNop = addLabelToOperation(operationNop, labelEnd);
    addOperationToIlocList(operationList, operationNop);

    $$->outRegister = r4;
    $$->operationList = operationList;
};

expression_grade_five: expression_grade_five TK_OC_GE expression_grade_four
{
    $$ = createNodeFromLabel($2, inferTypeFromNodes($1, $3));
    addChild($$, $1);
    addChild($$, $3);

    ///////////////////////// ETAPA 5 /////////////////////////
    IlocOperationList* operationList = joinOperationLists($1->operationList, $3->operationList);

    int r1 = $1->outRegister;
    int r2 = $3->outRegister;
    int r3 = generateRegister();
    int r4 = generateRegister();
    int labelTrue = generateLabel();
    int labelFalse = generateLabel();
    int labelEnd = generateLabel();

    IlocOperation operationCmpGE = generateOperation(OP_CMP_GE, r1, r2, r3, -1);
    addOperationToIlocList(operationList, operationCmpGE);

    IlocOperation operationCbr = generateOperation(OP_CBR, r3, -1, labelTrue, labelFalse);
    addOperationToIlocList(operationList, operationCbr);

    // IF TRUE
    IlocOperation operationTrue = generateOperation(OP_LOADI, 1, -1, r4, -1);
    operationTrue = addLabelToOperation(operationTrue, labelTrue);
    IlocOperation operationJumpTrue = generateOperation(OP_JUMPI, labelEnd, -1, -1, -1);
    addOperationToIlocList(operationList, operationTrue);
    addOperationToIlocList(operationList, operationJumpTrue);

    // ELSE
    IlocOperation operationFalse = generateOperation(OP_LOADI, 0, -1, r4, -1);
    operationFalse = addLabelToOperation(operationFalse, labelFalse);
    addOperationToIlocList(operationList, operationFalse);

    // NOP
    IlocOperation operationNop = generateNopOperation();
    operationNop = addLabelToOperation(operationNop, labelEnd);
    addOperationToIlocList(operationList, operationNop);

    $$->outRegister = r4;
    $$->operationList = operationList;
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

    ///////////////////////// ETAPA 5 /////////////////////////
    IlocOperationList* operationList = joinOperationLists($1->operationList, $3->operationList);

    int r1 = $1->outRegister;
    int r2 = $3->outRegister;
    int r3 = generateRegister();

    IlocOperation operation = generateOperation(OP_ADD, r1, r2, r3, -1);
    addOperationToIlocList(operationList, operation);

    $$->outRegister = r3;
    $$->operationList = operationList;
};

expression_grade_four: expression_grade_four '-' expression_grade_three
{
    $$ = createNodeFromLabel($2, inferTypeFromNodes($1, $3));
    addChild($$, $1);
    addChild($$, $3);

    ///////////////////////// ETAPA 5 /////////////////////////
    IlocOperationList* operationList = joinOperationLists($1->operationList, $3->operationList);

    int r1 = $1->outRegister;
    int r2 = $3->outRegister;
    int r3 = generateRegister();

    IlocOperation operation = generateOperation(OP_SUB, r1, r2, r3, -1);
    addOperationToIlocList(operationList, operation);

    $$->outRegister = r3;
    $$->operationList = operationList;
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

    ///////////////////////// ETAPA 5 /////////////////////////
    IlocOperationList* operationList = joinOperationLists($1->operationList, $3->operationList);

    int r1 = $1->outRegister;
    int r2 = $3->outRegister;
    int r3 = generateRegister();

    IlocOperation operation = generateOperation(OP_MULT, r1, r2, r3, -1);
    addOperationToIlocList(operationList, operation);

    $$->outRegister = r3;
    $$->operationList = operationList;
};

expression_grade_three: expression_grade_three '/' expression_grade_two
{
    $$ = createNodeFromLabel($2, inferTypeFromNodes($1, $3));
    addChild($$, $1);
    addChild($$, $3);

    ///////////////////////// ETAPA 5 /////////////////////////
    IlocOperationList* operationList = joinOperationLists($1->operationList, $3->operationList);

    int r1 = $1->outRegister;
    int r2 = $3->outRegister;
    int r3 = generateRegister();

    IlocOperation operation = generateOperation(OP_DIV, r1, r2, r3, -1);
    addOperationToIlocList(operationList, operation);

    $$->outRegister = r3;
    $$->operationList = operationList;
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

    ///////////////////////// ETAPA 5 /////////////////////////
    IlocOperationList* operationList = createListFromOtherList($2->operationList);

    int r1 = $2->outRegister;
    int r2 = generateRegister();

    IlocOperation operation = generateOperation(OP_NEG, r1, -1, r2, -1);
    addOperationToIlocList(operationList, operation);

    $$->outRegister = r2;
    $$->operationList = operationList;
};

expression_grade_two: '!' expression_grade_one
{
    $$ = createNodeFromLabel($1, inferTypeFromNode($2));
    addChild($$, $2);

    ///////////////////////// ETAPA 5 /////////////////////////
    // TODO: como implementar isso com as operações ILOC???
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

    ///////////////////////// ETAPA 5 /////////////////////////
    IlocOperationList* operationList = createIlocOperationList();
    SymbolTableEntryValue symbol = getSymbolFromStackByKey($1.label);

    int address = symbol.position;
    int r1 = generateRegister();

    IlocOperation operation;
    
    if (symbol.isGlobal)
    {
        operation = generateOperation(OP_LOADAI_GLOBAL, address, -1, r1, -1);
    }
    else
    {
        operation = generateOperation(OP_LOADAI_LOCAL, address, -1, r1, -1);
    }

    addOperationToIlocList(operationList, operation);

    $$->outRegister = r1;
    $$->operationList = operationList;
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