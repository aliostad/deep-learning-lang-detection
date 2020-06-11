#include <stdio.h>
#include "debug.h"


#include <vector>


bool dump_start_ = false;




void DumpStart(const char* c)
{
	FILE *f = NULL;
	fopen_s(&f, "dump.txt","wt");
	if (f != NULL) {
		fprintf(f,c);
	}
	fclose(f);
	dump_start_ = true;
}

void DumpContinue(const char* c)
{
	if(!dump_start_)
		return;
	FILE *f = NULL;
	fopen_s(&f, "dump.txt","at");
	if (f != NULL) {
		fprintf(f,c);
	}
	fclose(f);
}


void DumpEnd(const char* c)
{
	if(!dump_start_)
		return;
	FILE *f = NULL;
	fopen_s(&f, "dump.txt","at");
	if (f != NULL) {
		fprintf(f,c);
	}
	fclose(f);
	dump_start_ = false;
}