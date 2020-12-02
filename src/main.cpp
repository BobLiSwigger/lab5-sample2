#include "common.h"
#include <fstream>

extern TreeNode *root;
extern std::vector<std::string> symTable;
extern std::vector<int> symStack;
extern FILE *yyin;
extern int yyparse();

using namespace std;
int main(int argc, char *argv[])
{
    if (argc == 2)
    {
        FILE *fin = fopen(argv[1], "r");
        if (fin != nullptr)
        {
            yyin = fin;
        }
        else
        {
            cerr << "failed to open file: " << argv[1] << endl;
        }
    }
    yyparse();
    if(root != NULL) {
        root->genNodeId(0);
        root->printAST();
        cout<<"Symbol Table"<<endl;
        for (long unsigned int i = 0; i < symTable.size(); i = i + 1){
            cout<<i<<"\t"<<symTable[i]<<endl;
        }
    }
    return 0;
}