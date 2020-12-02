#ifndef TREE_H
#define TREE_H

#include "pch.h"
#include "type.h"
#include "utility.h"

enum NodeType
{
    NODE_CONST = 1, 
    NODE_VAR,
    NODE_EXPR,
    NODE_TYPE,

    NODE_STMT,
    NODE_PROG
};

enum OperatorType
{
    OP_ASSIGN = 1,

    OP_EQ,  // ==
    OP_G,
    OP_L,
    OP_GEQ,
    OP_LEQ,
    OP_NEQ,
    OP_AND,
    OP_OR,
    OP_NOT,
    
    OP_PLUS,
    OP_SUB,
    OP_MULT,
    OP_DIV,
    OP_MOD,

    OP_GETADDR,

    OP_PLUSEQ,
    OP_SUBEQ,
    OP_MULTEQ,
    OP_DIVEQ,
    OP_MODEQ,

    OP_FRONTPP,
    OP_TAILPP,
    OP_FRONTSS,
    OP_TAILSS,
    OP_UNARYP,
    OP_UNARYS
};

enum StmtType {
    STMT_SKIP = 1,
    STMT_RETURN,
    STMT_DECL,
    STMT_IF,
    STMT_WHILE,
    STMT_FOR,
    STMT_PRINTF,
    STMT_SCANF
};

struct TreeNode {
public:
    int nodeID;  // 用于作业的序号输出
    int lineno;
    NodeType nodeType;

    TreeNode* child = nullptr;
    TreeNode* sibling = nullptr;

    void addChild(TreeNode*);
    void addSibling(TreeNode*);
    
    void printNodeInfo();
    void printChildrenId();

    void printAST(); // 先输出自己 + 孩子们的id；再依次让每个孩子输出AST。
    void printSpecialInfo();

    int genNodeId(int startID);

public:
    OperatorType optype;  // 如果是表达式
    Type* type;  // 变量、类型、表达式结点，有类型。
    StmtType stype;
    int int_val;
    char ch_val;
    bool b_val;
    string str_val;
    string var_name;
    int var_p;

public:
    static string nodeType2String (NodeType type);
    static string opType2String (OperatorType type);
    static string sType2String (StmtType type);

public:
    TreeNode(int lineno, NodeType type);
};

#endif