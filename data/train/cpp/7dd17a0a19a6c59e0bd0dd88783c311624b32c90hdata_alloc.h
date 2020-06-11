/*
 *  hdata_writer.h
 *  C Library
 *
 *  Created by hailong zhang on 10-10-10.
 *  Copyright 2010 hailongz. All rights reserved.
 *
 */

#ifndef HDATA_ALLOC_H
#define HDATA_ALLOC_H

#include "hmem.h"
#include "hdata.h"
#include "hmap.h"
#include "hbuffer.h"
#include "hext_obj.h"

#ifdef __cplusplus
extern "C" {
#endif
	
	extern hdata_class_t hdata_class;
	
	hdata_t hdata_null_alloc(InvokeTickDeclare);
	
	hdata_t hdata_object_alloc(InvokeTickDeclare);
	
	hdata_t hdata_array_alloc(hint32 capacity,hint32 extendSize,InvokeTickDeclare);
	
	hdata_t hdata_int16_alloc(hint16 value,InvokeTickDeclare);
	
	hdata_t hdata_int32_alloc(hint32 value,InvokeTickDeclare);
	
	hdata_t hdata_int64_alloc(hint64 value,InvokeTickDeclare);
	
	hdata_t hdata_double_alloc(hdouble value,InvokeTickDeclare);
	
	hdata_t hdata_boolean_alloc(hbool value,InvokeTickDeclare);
	
	hdata_t hdata_string_alloc(hcchar * value,InvokeTickDeclare);

    hdata_t hdata_bytes_alloc(hbyte * data,hint32 length,InvokeTickDeclare);
	
	void hdata_object_put(hdata_t data,hcchar * key,hdata_t value,InvokeTickDeclare);
	
	void hdata_object_remove(hdata_t data,hcchar * key,InvokeTickDeclare);
	
	hmap_t hdata_object_map(hdata_t data,InvokeTickDeclare);
	
	void hdata_array_add(hdata_t data,hdata_t value,InvokeTickDeclare);
	
	void hdata_array_remove(hdata_t data,hint32 index,InvokeTickDeclare);
	
	void hdata_dealloc(hdata_t data,InvokeTickDeclare);

	hdata_t hdata_clone(const hdata_class_t *data_class,hdata_t data,InvokeTickDeclare);
    
    
    
    
#define hdata_null_alloc() hdata_null_alloc(InvokeTickArg)
	
#define hdata_object_alloc() hdata_object_alloc(InvokeTickArg)
	
#define hdata_array_alloc(a,b) hdata_array_alloc((a),(b),InvokeTickArg)
	
#define hdata_int16_alloc(a) hdata_int16_alloc((a),InvokeTickArg)
	
#define hdata_int32_alloc(a) hdata_int32_alloc((a),InvokeTickArg)
	
#define hdata_int64_alloc(a) hdata_int64_alloc((a),InvokeTickArg)
	
#define hdata_double_alloc(a) hdata_double_alloc((a),InvokeTickArg)
	
#define hdata_boolean_alloc(a) hdata_boolean_alloc((a),InvokeTickArg)
	
#define hdata_string_alloc(a) hdata_string_alloc((a),InvokeTickArg)
    
#define hdata_bytes_alloc(a,b) hdata_bytes_alloc((a),(b),InvokeTickArg)
	
#define hdata_object_put(a,b,c) hdata_object_put((a),(b),(c),InvokeTickArg)
	
#define hdata_object_remove(a,b) hdata_object_remove((a),(b),InvokeTickArg)
	
#define hdata_object_map(a) hdata_object_map((a),InvokeTickArg)
	
#define hdata_array_add(a,b) hdata_array_add((a),(b),InvokeTickArg)
	
#define hdata_array_remove(a,b) hdata_array_remove((a),(b),InvokeTickArg)
	
#define hdata_dealloc(a) hdata_dealloc((a),InvokeTickArg)
    
#define hdata_clone(a,b) hdata_clone((a),(b),InvokeTickArg)

	
#ifdef __cplusplus
}
#endif


#endif
