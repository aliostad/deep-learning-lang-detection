#ifndef _DUMPS_H
#define _DUMPS_H

#include "extmath.h"

void create_wfilter(f_complex* wfilter, const char* name);
void create_longpass_filter(f_complex* wfilter, float_type lambda);
void create_shortpass_filter(f_complex* wfilter, float_type lambda);



class dump_type_empty_class
{
protected:
	FILE* dumpfid;
	int   tN, xN, yN, zN;
	int   nz_denom;

	int  iscomplex;
	long int piece_size;
	long int header_ofs;


	dump_type_empty_class() {};
	virtual long int fileofs() = 0;

public:

   ~dump_type_empty_class();

    virtual void init_dumpfile(const char* filename);
	virtual void init_dumpfile(FILE* fid, int i);

	virtual  void dump();
    virtual  void dump_write(void* buf);
	virtual  void dump_noflush() = 0;
};


class dump_type_full_class : public dump_type_empty_class
{
protected:
	dump_type_full_class() {};
    virtual long int fileofs();
public:
	dump_type_full_class(FILE* optfid, int i);
    
	virtual void dump_noflush();
	~dump_type_full_class() {};
};

class dump_type_maxI_class : public dump_type_empty_class
{
protected:
		f_complex* wfilter;
        virtual long int fileofs();

		dump_type_maxI_class() {};
public:
	     dump_type_maxI_class(FILE* optfid, int i);
		 ~dump_type_maxI_class();
	     virtual void dump_noflush();
	    
};

class dump_type_flux_class : public dump_type_maxI_class
{
public:
	dump_type_flux_class(FILE* optfid, int i) : dump_type_maxI_class(optfid, i) {};
	~dump_type_flux_class() {};
	virtual void dump_noflush();
	  
};

class dump_type_duration_class : public dump_type_maxI_class
{
public:
	dump_type_duration_class(FILE* optfid, int i) : dump_type_maxI_class(optfid, i) {}; 
	~dump_type_duration_class() {};
	virtual void dump_noflush(); 
};

class dump_type_fluxk_class : public dump_type_maxI_class
{
public:
		dump_type_fluxk_class() {};
		dump_type_fluxk_class(FILE* optfid, int i); 
		~dump_type_fluxk_class() {};
		virtual void dump_noflush();
		virtual long int fileofs();

};

class dump_type_ysection_class : public dump_type_empty_class
{
protected:
	int ny;
	bool mydump;
	virtual long int fileofs();
	virtual void init_ny(FILE* fid, int num);
	dump_type_ysection_class() {};
	fftwt_plan fft_bwplan_sectiont; 
public:
	dump_type_ysection_class(FILE* optfid, int num);
   ~dump_type_ysection_class() {};

   virtual void dump_noflush();
};

class dump_type_ysectionk_class : public dump_type_ysection_class
{
protected:
	virtual void init_ny(FILE* fid, int num);
	virtual long int fileofs();
public:
	dump_type_ysectionk_class(FILE* optfid, int num);
	virtual void dump_noflush();
};

class dump_type_ysection_maxI_class : public dump_type_ysection_class
{
protected:
	f_complex* wfilter; 
	dump_type_ysection_maxI_class() {};
public:
	dump_type_ysection_maxI_class(FILE* optfid, int num);
   ~dump_type_ysection_maxI_class();
	virtual void dump_noflush();
};

class dump_type_ysection_flux_class : public dump_type_ysection_maxI_class
{
public:
	dump_type_ysection_flux_class(FILE* optfid, int num) : dump_type_ysection_maxI_class(optfid,num) {};
   ~dump_type_ysection_flux_class() {};
   virtual void dump_noflush();
};

class dump_type_youngy_class : public dump_type_ysection_maxI_class
{
public:
	dump_type_youngy_class(FILE* optfid, int num);
	~dump_type_youngy_class();
	virtual void dump_noflush(); 
	virtual long int fileofs();
};
 
class dump_type_field_axis_class : public dump_type_empty_class
{
protected:
	virtual long int fileofs();
	dump_type_field_axis_class() {};
public:
	dump_type_field_axis_class(FILE* optfid, int num);
	~dump_type_field_axis_class() {};
	virtual void dump_noflush();
};

class dump_type_plasma_axis_class : public dump_type_field_axis_class
{
protected:
	dump_type_plasma_axis_class() {};
public:
	dump_type_plasma_axis_class(FILE* optfid, int num);
	~dump_type_plasma_axis_class() {};
	virtual void dump_noflush();
};

class dump_type_Z_axis_class : public dump_type_plasma_axis_class
{
protected:
	dump_type_Z_axis_class() {};
public:
	dump_type_Z_axis_class(FILE* optfid, int num) : dump_type_plasma_axis_class(optfid, num) {};
	~dump_type_Z_axis_class() {};
	virtual void dump_noflush(); 
};


class dump_type_average_spectrum_class : public dump_type_field_axis_class
{
protected:
	dump_type_average_spectrum_class() {};
public:
	dump_type_average_spectrum_class(FILE* optfid, int num);
	~dump_type_average_spectrum_class() {};
	virtual void dump_noflush();
};

class dump_type_full_plasma_class : public dump_type_full_class
{
protected:
	dump_type_full_plasma_class() {};

public:
	dump_type_full_plasma_class(FILE* fid, int num);
   ~dump_type_full_plasma_class() {};
	virtual void dump_noflush();
};

class dump_type_plasma_max_class : public dump_type_maxI_class
{
protected:
	dump_type_plasma_max_class() {};
public:
	dump_type_plasma_max_class(FILE* fid, int num);
   ~dump_type_plasma_max_class() {};
	virtual void dump_noflush();
};

class dump_type_ysection_plasma_class : public dump_type_ysection_class
{
protected:
	dump_type_ysection_plasma_class() {};
public:
	dump_type_ysection_plasma_class(FILE* fid, int num);
   ~dump_type_ysection_plasma_class() {};
	virtual void dump_noflush();
};

class dump_type_ysection_plasma_max_class : public dump_type_ysection_plasma_class
{
protected:
	dump_type_ysection_plasma_max_class() {};
public:
	dump_type_ysection_plasma_max_class(FILE* fid, int num);
   ~dump_type_ysection_plasma_max_class() {};
    virtual void dump_noflush();
};




class dump_manager_class
{
	int dumpN;
	dump_type_empty_class** dump_slaves;

	dump_manager_class();
public:
	dump_manager_class(FILE* optfid);
   ~dump_manager_class();
	void dump();
};
#endif 
