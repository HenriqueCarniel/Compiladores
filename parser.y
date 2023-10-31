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

/* 3 */
programa: elementsList |
elementsList: elementsList globalVariable | elementsList function | globalVariable | function

/* 3.1 */
globalVariable: type identifierList ';' 
type: TK_PR_INT | TK_PR_FLOAT | TK_PR_BOOL
identifierList: TK_IDENTIFICADOR | identifierList ',' TK_IDENTIFICADOR

/* 3.2 */
function: header body
header: argument TK_OC_GE type '!' TK_IDENTIFICADOR
body: commandBlock
argument: '(' ')' | '(' parameterList ')'
parameterList: parameterList ',' parameter | parameter
parameter: type TK_IDENTIFICADOR

/* 3.3 */
commandBlock: '{' '}' | '{' commandList '}'
commandList: command ';' | commandList command ';'

command: commandBlock | 



%%
