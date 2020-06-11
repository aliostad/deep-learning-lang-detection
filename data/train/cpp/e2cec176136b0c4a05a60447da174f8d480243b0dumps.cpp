#include "dumps.h"
#include "solver.h"

dump_manager_class :: dump_manager_class()
{
	
}

dump_manager_class :: ~dump_manager_class()
{
	for (int i=0; i<dumpN; i++) delete (dump_slaves[i]);
	free(dump_slaves);
}

dump_manager_class :: dump_manager_class(FILE* optfid)
{
	dumpN = load_namedint(optfid, "DUMPS_N", true, 0);
	dump_slaves = (dump_type_empty_class**)malloc_ch(sizeof(dump_type_empty_class*)*dumpN);
	for (int i=0; i<dumpN; i++)
	{
		char cbuf[100];
		load_namednumstringn(optfid, "DUMPTYPE", cbuf, i, 100, false);
		if      (strcmp(cbuf, "full")==0)            dump_slaves[i] = new dump_type_full_class               (optfid,i); 
		else if (strcmp(cbuf, "maxI")==0)            dump_slaves[i] = new dump_type_maxI_class               (optfid,i);  
		else if (strcmp(cbuf, "flux")==0)            dump_slaves[i] = new dump_type_flux_class               (optfid,i);  
		else if (strcmp(cbuf, "ysection")==0)        dump_slaves[i] = new dump_type_ysection_class           (optfid,i);
		else if (strcmp(cbuf, "ysection_maxI")==0)   dump_slaves[i] = new dump_type_ysection_maxI_class      (optfid,i);
		else if (strcmp(cbuf, "ysection_flux")==0)   dump_slaves[i] = new dump_type_ysection_flux_class      (optfid,i);  
		else if (strcmp(cbuf, "plasma_full")==0)         dump_slaves[i] = new dump_type_full_plasma_class         (optfid,i);
		else if (strcmp(cbuf, "plasma_max")==0)          dump_slaves[i] = new dump_type_plasma_max_class          (optfid,i);
		else if (strcmp(cbuf, "plasma_ysection")==0)     dump_slaves[i] = new dump_type_ysection_plasma_class     (optfid,i);
		else if (strcmp(cbuf, "plasma_ysection_max")==0) dump_slaves[i] = new dump_type_ysection_plasma_max_class (optfid,i);
		else if (strcmp(cbuf, "youngy")==0)              dump_slaves[i] = new dump_type_youngy_class(optfid, i);
		else if (strcmp(cbuf, "fluxk") ==0)              dump_slaves[i] = new dump_type_fluxk_class(optfid, i);
		else if (strcmp(cbuf, "ysectionk")==0)           dump_slaves[i] = new dump_type_ysectionk_class(optfid,i);
		else if (strcmp(cbuf, "field_axis") ==0)         dump_slaves[i] = new dump_type_field_axis_class(optfid,i);
		else if (strcmp(cbuf, "plasma_axis")==0)         dump_slaves[i] = new dump_type_plasma_axis_class(optfid,i);
		else if (strcmp(cbuf, "Z_axis")==0)              dump_slaves[i] = new dump_type_Z_axis_class(optfid,i);
		else if (strcmp(cbuf, "average_spectrum")==0)    dump_slaves[i] = new dump_type_average_spectrum_class(optfid,i);
		else if (strcmp(cbuf, "duration")==0)            dump_slaves[i] = new dump_type_duration_class(optfid, i); 
		else throw "dump_manager_class :: dump_manager_class(FILE* fid) >>> Error! Unknown dump type specified! Revise DUMPTYPE values";

	}
	
}

void dump_manager_class :: dump()
{
	if (ISMASTER) printf("\nDumping (n_Z=%d, Z=%f)...", n_Z, CURRENT_Z); 
	for (int i=0; i<dumpN; i++) dump_slaves[i]->dump_noflush();
	if (ISMASTER) printf("Done.");
}


void create_wfilter(f_complex* wfilter, const char* name)
{
	//TODO: Other filters
	if        (strncmp(name, "longpass",8)==0)  {float_type lambda=(float_type)atof(name+8); create_longpass_filter(wfilter,lambda);}
	else if   (strncmp(name, "lp",2)==0)        {float_type lambda=(float_type)atof(name+2); create_longpass_filter(wfilter,lambda);}
	else if   (strncmp(name, "shortpass",9)==0) {float_type lambda=(float_type)atof(name+9); create_shortpass_filter(wfilter,lambda);}
	else if   (strncmp(name, "sp",2)==0)        {float_type lambda=(float_type)atof(name+2); create_shortpass_filter(wfilter,lambda);}
	else if   (strncmp(name, "NO",2)==0)        {for (int nw=0; nw<N_T; nw++) wfilter[nw]=1.0; }
	else if   (strncmp(name, "file_",5)==0)     {load_spectrum_fromfile(wfilter, OMEGA, N_T, name+5, "text_lambdanm");}
	else throw "create_wfilter: Unknown filter shape!";
}

void create_longpass_filter(f_complex* wfilter, float_type lambda)
{
	float_type omega = 2*M_PI*LIGHT_VELOCITY/lambda;
	for (int nw=0; nw<N_T; nw++) if (OMEGA[nw]<omega) wfilter[nw]=1.0; else wfilter[nw]=0.0;
}

void create_shortpass_filter(f_complex* wfilter, float_type lambda)
{
	float_type omega = 2*M_PI*LIGHT_VELOCITY/lambda;
	for (int nw=0; nw<N_T; nw++) if (OMEGA[nw]>omega) wfilter[nw]=1.0; else wfilter[nw]=0.0;
}


void create_filter_fromfile(f_complex* wfilter, char* filename)
{
	FILE* fid = fopen(filename, "rt");

}
