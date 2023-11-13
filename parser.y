/* ======= GRUPO A =======
Henrique Carniel da Silva 
Jose Henrique Lima Marques */

%{
int yylex(void);
void yyerror (char const *mensagem);
%}

%define parse.error verbose

%token TK_PR_INT
%token TK_PR_FLOAT
%token TK_PR_BOOL
%token TK_PR_IF
%token TK_PR_ELSE
%token TK_PR_WHILE
%token TK_PR_RETURN
%token TK_OC_LE
%token TK_OC_GE
%token TK_OC_EQ
%token TK_OC_NE
%token TK_OC_AND
%token TK_OC_OR
%token TK_IDENTIFICADOR
%token TK_LIT_INT
%token TK_LIT_FLOAT
%token TK_LIT_FALSE
%token TK_LIT_TRUE
%token TK_ERRO

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

expression_grade_two: minus_loop expression_grade_one;
expression_grade_two: negation_loop expression_grade_one;
expression_grade_two: expression_grade_one;

minus_loop: minus_loop '-' | '-';
negation_loop: negation_loop '!' | '!';

expression_grade_one: TK_IDENTIFICADOR;
expression_grade_one: literal;
expression_grade_one: function_call;
expression_grade_one: '(' expression ')';

%%
