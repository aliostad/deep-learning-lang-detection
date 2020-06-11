/*
 *  hinifile.h
 *  C Library
 *
 *  Created by hailong zhang on 10-10-13.
 *  Copyright 2010 hailongz. All rights reserved.
 *
 */

#ifndef HINIFILE_H
#define HINIFILE_H

#include "hmem.h"


#ifdef __cplusplus
extern "C" {
#endif

	HANDLER(hinifile_t)
	
	hinifile_t inifile_alloc(hcchar * file_path,InvokeTickDeclare);
	
	void inifile_dealloc(hinifile_t inifile,InvokeTickDeclare);
	
	hbool inifile_read(hinifile_t inifile,InvokeTickDeclare);
	
	hcchar * inifile_section(hinifile_t inifile,InvokeTickDeclare);
	
	hcchar * inifile_key(hinifile_t inifile,InvokeTickDeclare);
	
	hcchar * inifile_value(hinifile_t inifile,InvokeTickDeclare);
	
	
    
    
#define inifile_alloc(a) inifile_alloc((a),InvokeTickArg)
	
#define inifile_dealloc(a) inifile_dealloc((a),InvokeTickArg)
	
#define inifile_read(a) inifile_read((a),InvokeTickArg)
	
#define inifile_section(a) inifile_section((a),InvokeTickArg)
	
#define inifile_key(a) inifile_key((a),InvokeTickArg)
	
#define inifile_value(a) inifile_value((a),InvokeTickArg)
    
    
#ifdef __cplusplus
}
#endif

#endif

