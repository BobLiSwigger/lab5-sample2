%option nounput
%{
#include "common.h"
#include "main.tab.h"  // yacc header
extern std::vector<std::string> symTable;
extern std::vector<int> symStack;
int lineno=1;
%}
BLOCKCOMMENT \/\*([^\*^\/]*|[\*^\/*]*|[^\**\/]*)*\*\/
LINECOMMENT \/\/[^\n]*
EOL	(\r\n|\r|\n)
WHILTESPACE [[:blank:]]

INTEGER [0-9]+

CHAR \'.?\'
STRING \"([^\"^\\]|\\n|\\t|\\r)+\"

IDENTIFIER [[:alpha:]_][[:alpha:][:digit:]_]*
%%

{BLOCKCOMMENT}  /* do nothing */
{LINECOMMENT}  /* do nothing */

{STRING} {
    TreeNode *node = new TreeNode(lineno, NODE_CONST);
    node->type = TYPE_STRING;
    node->str_val = string(yytext);
    yylval = node;
    return STRING;
}

"++" return LOP_PLUSPLUS;
"--" return LOP_SUBSUB;

"!" return LOP_NOT;

"==" return LOP_EQ;
"!=" return LOP_NEQ;
"+=" return LOP_PLUSEQ;
"-=" return LOP_SUBEQ;
"*=" return LOP_MULTEQ;
"/=" return LOP_DIVEQ;
"%=" return LOP_MODEQ;

"*" return LOP_MULT;
"/" return LOP_DIV;
"%" return LOP_MOD;
"+" return LOP_PLUS;
"-" return LOP_SUB;
">=" return LOP_GEQ;
"<=" return LOP_LEQ;
">" return LOP_G;
"<" return LOP_L;

"&&" return LOP_AND;
"||" return LOP_OR;
"=" return LOP_ASSIGN;
"&" return LOP_LAB;

";" return  SEMICOLON;
"," return COMMA;

"if" return IF;
"while" return WHILE;
"for" return FOR;
"return" return RETURN;
"printf" return PRINTF;
"scanf" return SCANF;

"int" return T_INT;
"bool" return T_BOOL;
"char" return T_CHAR;
"void" return T_VOID;


"(" {return LP;}
")" {return RP;}
"[" {return LBCT;}
"]" {return RBCT;}
"{" {symStack.push_back(-1);
     return LB;}
"}" {for (;symStack[symStack.size()-1] >= 0;symStack.pop_back());
     symStack.pop_back();
     return RB;}

{INTEGER} {
    TreeNode* node = new TreeNode(lineno, NODE_CONST);
    node->type = TYPE_INT;
    node->int_val = atoi(yytext);
    yylval = node;
    return INTEGER;
}

{CHAR} {
    TreeNode* node = new TreeNode(lineno, NODE_CONST);
    node->type = TYPE_CHAR;
    node->ch_val = yytext[1];
    yylval = node;
    return CHAR;
}

{IDENTIFIER} {
    TreeNode* node = new TreeNode(lineno, NODE_VAR);
    long int p;
    /*查找已经存在的最近变量*/
    for (p = symStack.size() - 1; p >= 0; p = p - 1){
        /*判断不是边界*/
        if (symStack[p] >= 0){
            /*如果已经声明*/
            if (symTable[symStack[p]] == string(yytext)){
                break;
            }
        }
    }
    if (p < 0){
        symTable.push_back(string(yytext));
        symStack.push_back(symTable.size() - 1);
        node->var_p = symTable.size() - 1;
    }
    else{
        node->var_p = symStack[p];
    }
    node->var_name = string(yytext);
    yylval = node;
    return IDENTIFIER;
}

{WHILTESPACE} /* do nothing */

{EOL} lineno++;

. {
    cerr << "[line "<< lineno <<" ] unknown character:" << yytext << endl;
}
%%