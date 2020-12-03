%{
    #include "common.h"
    #define YYSTYPE TreeNode *  
    TreeNode* root;
    struct Yields progYields;
    extern int lineno;
    int yylex();
    int yyerror( char const * );
%}

%token LP RP LBCT RBCT LB RB

%token IF WHILE FOR RETURN PRINTF SCANF

%token T_CHAR T_INT T_STRING T_BOOL T_VOID T_CONST

%token SEMICOLON COMMA

%token IDENTIFIER INTEGER CHAR BOOL STRING

%left LOP_ASSIGN
%left LOP_OR
%left LOP_AND
%left LOP_EQ LOP_NEQ LOP_PLUSEQ LOP_SUBEQ LOP_MULTEQ LOP_DIVEQ LOP_MODEQ
%left LOP_G LOP_L LOP_GEQ LOP_LEQ
%left LOP_PLUS LOP_SUB
%left LOP_MULT LOP_DIV LOP_MOD
%left LOP_NOT LOP_LAB
%left LOP_PLUSPLUS LOP_SUBSUB

%%

program
: statements {root = new TreeNode(0, NODE_PROG); root->addChild($1);}
;

statements
:  statement {$$=$1;}
|  statements statement {$$=$1; $$->addSibling($2);}
;

statement
: SEMICOLON  {$$ = new TreeNode(lineno, NODE_STMT); $$->stype = STMT_SKIP;}
| RETURN expr SEMICOLON {$$ = new TreeNode(lineno, NODE_STMT); $$->stype = STMT_RETURN; $$->addChild($2);}
| RETURN SEMICOLON {$$ = new TreeNode(lineno, NODE_STMT); $$->stype = STMT_RETURN;}
| declaration {$$ = $1;}
| expr SEMICOLON {$$ = $1;}
| PRINTF LP exprs RP SEMICOLON {$$ = new TreeNode(lineno, NODE_STMT); $$->stype = STMT_PRINTF; $$->addChild($3);}
| SCANF LP exprs RP SEMICOLON {$$ = new TreeNode(lineno, NODE_STMT); $$->stype = STMT_SCANF; $$->addChild($3);}
| IF LP expr RP LB statements RB {$$ = new TreeNode(lineno, NODE_STMT); 
                                  $$->stype = STMT_IF; 
                                  $$->addChild($3);
                                  $$->addChild($6);}
| WHILE LP expr RP LB statements RB {$$ = new TreeNode($3->lineno, NODE_STMT);
                                     $$->stype = STMT_WHILE;
                                     $$->addChild($3);
                                     $$->addChild($6);}
| FOR LP statement expr SEMICOLON expr RP LB statements RB {$$ = new TreeNode($3->lineno, NODE_STMT);
                                                            $$->stype = STMT_FOR;
                                                            $$->addChild($3);
                                                            $$->addChild($4);
                                                            $$->addChild($6);
                                                            $$->addChild($9);}
;

declaration
: T decl_exprs SEMICOLON {$$ = new TreeNode($1->lineno, NODE_STMT);
                          $$->stype = STMT_DECL;
                          $$->addChild($1);
                          $$->addChild($2);} 
| T IDENTIFIER LP RP LB statements RB {/*int diff;*/
                                       /*struct Symbol * lastSymbol = progYields.ifExists($2->yield_offset, $2->var_name, &diff);*/
                                       struct Symbol * curSymbol = progYields.addSym($2->yield_offset, $2->var_name);
                                       $2->symbol_p = curSymbol;
                                       $$ = new TreeNode($1->lineno, NODE_STMT);
                                       $$->stype = STMT_DECL;
                                       $$->addChild($1);
                                       $$->addChild($2);
                                       $$->addChild($6);}
;

decl_exprs
: decl_expr {$$ = $1;}
| decl_exprs COMMA decl_expr {$$ = $1; $$->addSibling($3);}
;

decl_expr
: IDENTIFIER {$$ = $1;
              /*int diff;*/
              /*struct Symbol * lastSymbol = progYields.ifExists($$->yield_offset, $$->var_name, &diff);*/
              $$->symbol_p = progYields.addSym($$->yield_offset, $$->var_name);}
| IDENTIFIER LOP_ASSIGN expr {/*int diff;*/
                              /*struct Symbol * lastSymbol = progYields.ifExists($1->yield_offset, $1->var_name, &diff);*/
                              $1->symbol_p = progYields.addSym($1->yield_offset, $1->var_name);
                              $$ = new TreeNode(lineno, NODE_EXPR); 
                              $$->optype = OP_ASSIGN;
                              $$->addChild($1); 
                              $$->addChild($3);}
;

exprs
: expr {$$ = $1;}
| exprs COMMA expr {$$ = $1; $$->addSibling($3);}
;

expr
: VALUE {$$ = $1;}
| LOP_PLUSPLUS expr {$$ = new TreeNode(lineno, NODE_EXPR); $$->optype = OP_FRONTPP; $$->addChild($2);}
| expr LOP_PLUSPLUS {$$ = new TreeNode(lineno, NODE_EXPR); $$->optype = OP_TAILPP; $$->addChild($1);}
| LOP_SUBSUB expr {$$ = new TreeNode(lineno, NODE_EXPR); $$->optype = OP_FRONTSS; $$->addChild($2);}
| expr LOP_SUBSUB {$$ = new TreeNode(lineno, NODE_EXPR); $$->optype = OP_TAILSS; $$->addChild($1);}
| LOP_NOT expr {$$ = new TreeNode(lineno, NODE_EXPR); $$->optype = OP_NOT; $$->addChild($2);/*逻辑非*/}
| LOP_LAB expr {$$ = new TreeNode(lineno, NODE_EXPR); $$->optype = OP_GETADDR; $$->addChild($2);/*取地址*/}
| LOP_PLUS expr {$$ = new TreeNode(lineno, NODE_EXPR); $$->optype = OP_UNARYP; $$->addChild($2);/*一元取正*/}
| LOP_SUB expr {$$ = new TreeNode(lineno, NODE_EXPR); $$->optype = OP_UNARYS; $$->addChild($2);/*一元取负*/}
| expr LOP_MULT expr {$$ = new TreeNode(lineno, NODE_EXPR); 
                      $$->optype = OP_MULT; 
                      $$->addChild($1); $$->addChild($3);}
| expr LOP_DIV expr {$$ = new TreeNode(lineno, NODE_EXPR); 
                     $$->optype = OP_DIV;
                     $$->addChild($1); 
                     $$->addChild($3);}
| expr LOP_MOD expr {$$ = new TreeNode(lineno, NODE_EXPR); 
                     $$->optype = OP_MOD;
                     $$->addChild($1); 
                     $$->addChild($3);}
| expr LOP_PLUS expr {$$ = new TreeNode(lineno, NODE_EXPR); 
                     $$->optype = OP_PLUS;
                     $$->addChild($1); 
                     $$->addChild($3);}
| expr LOP_SUB expr {$$ = new TreeNode(lineno, NODE_EXPR); 
                     $$->optype = OP_SUB;
                     $$->addChild($1); 
                     $$->addChild($3);}
| expr LOP_G expr {$$ = new TreeNode(lineno, NODE_EXPR); 
                   $$->optype = OP_G;
                   $$->addChild($1); 
                   $$->addChild($3);}
| expr LOP_L expr {$$ = new TreeNode(lineno, NODE_EXPR); 
                   $$->optype = OP_L;
                   $$->addChild($1); 
                   $$->addChild($3);}
| expr LOP_GEQ expr {$$ = new TreeNode(lineno, NODE_EXPR); 
                     $$->optype = OP_GEQ;
                     $$->addChild($1); 
                     $$->addChild($3);}
| expr LOP_LEQ expr {$$ = new TreeNode(lineno, NODE_EXPR); 
                     $$->optype = OP_LEQ;
                     $$->addChild($1); 
                     $$->addChild($3);}
| expr LOP_EQ expr {$$ = new TreeNode(lineno, NODE_EXPR); 
                    $$->optype = OP_EQ;
                    $$->addChild($1); 
                    $$->addChild($3);}
| expr LOP_NEQ expr {$$ = new TreeNode(lineno, NODE_EXPR); 
                     $$->optype = OP_NEQ;
                     $$->addChild($1); 
                     $$->addChild($3);}
| expr LOP_PLUSEQ expr {$$ = new TreeNode(lineno, NODE_EXPR); 
                        $$->optype = OP_PLUSEQ;
                        $$->addChild($1); 
                        $$->addChild($3);}
| expr LOP_SUBEQ expr {$$ = new TreeNode(lineno, NODE_EXPR); 
                       $$->optype = OP_SUBEQ;
                       $$->addChild($1); 
                       $$->addChild($3);}
| expr LOP_MULTEQ expr {$$ = new TreeNode(lineno, NODE_EXPR); 
                        $$->optype = OP_MULTEQ;
                        $$->addChild($1); 
                        $$->addChild($3);}
| expr LOP_DIVEQ expr {$$ = new TreeNode(lineno, NODE_EXPR); 
                       $$->optype = OP_DIVEQ;
                       $$->addChild($1); 
                       $$->addChild($3);}
| expr LOP_MODEQ expr {$$ = new TreeNode(lineno, NODE_EXPR); 
                       $$->optype = OP_MODEQ;
                       $$->addChild($1); 
                       $$->addChild($3);}
| expr LOP_AND expr {$$ = new TreeNode(lineno, NODE_EXPR); 
                     $$->optype = OP_AND;
                     $$->addChild($1); 
                     $$->addChild($3);}
| expr LOP_OR expr {$$ = new TreeNode(lineno, NODE_EXPR); 
                    $$->optype = OP_OR;
                    $$->addChild($1); 
                    $$->addChild($3);}
| expr LOP_ASSIGN expr {$$ = new TreeNode(lineno, NODE_EXPR); 
                        $$->optype = OP_ASSIGN;
                        $$->addChild($1); 
                        $$->addChild($3);}
;

VALUE
: IDENTIFIER {
    $$ = $1;
    struct Symbol * symbol = progYields.ifExists($$->yield_offset, $$->var_name, NULL);
    if (symbol != NULL){
        $$->symbol_p = symbol;
    }
}
| INTEGER {
    $$ = $1;
}
| CHAR {
    $$ = $1;
}
| STRING {
    $$ = $1;
}
;

T: T_INT {$$ = new TreeNode(lineno, NODE_TYPE); $$->type = TYPE_INT;} 
| T_CHAR {$$ = new TreeNode(lineno, NODE_TYPE); $$->type = TYPE_CHAR;}
| T_BOOL {$$ = new TreeNode(lineno, NODE_TYPE); $$->type = TYPE_BOOL;}
| T_VOID {$$ = new TreeNode(lineno, NODE_TYPE); $$->type = TYPE_VOID;}
| T_CONST T_INT {$$ = new TreeNode(lineno, NODE_TYPE); $$->type = TYPE_INT; $$->isConst = true;} 
| T_CONST T_CHAR {$$ = new TreeNode(lineno, NODE_TYPE); $$->type = TYPE_INT; $$->isConst = true;} 
| T_CONST T_BOOL {$$ = new TreeNode(lineno, NODE_TYPE); $$->type = TYPE_INT; $$->isConst = true;} 
;

%%

int yyerror(char const* message)
{
  cout << message << " at line " << lineno << endl;
  return -1;
}