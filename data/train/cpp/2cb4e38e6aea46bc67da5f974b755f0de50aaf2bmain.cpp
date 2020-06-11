#include <stdio.h>
#include <stdlib.h>
#include "ExprProcessing.h"

int main()
{
    char inexpr[100];
    scanf ("%[^\n]s", inexpr); // scanf until \n

    tr_node* answer = Rec_Tree (inexpr);

    FILE* dump_file = fopen ("dumpfile.txt", "w");
    assert (dump_file);
    Tree_Dump (answer, dump_file);
    fclose (dump_file);

    dump_file = fopen ("dumpfile.txt", "a");
    assert (dump_file);

	
    tr_node* diff = Tree_Diff (answer);
    Tree_Dump (diff, dump_file);
	
	FILE* save_file = fopen ("savefile.txt", "w");
	assert (save_file);
	
	
	
    Tree_Optimisation (diff);

	Tree_Print_Math_Expr (save_file, diff);
	
    Tree_Dump (diff, dump_file);

    Tree_Destructor (answer);
    fclose (dump_file);
	fclose (save_file);

    return 0;
}
