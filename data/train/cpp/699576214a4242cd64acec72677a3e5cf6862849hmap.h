/*
 *  btree.h
 *  C Library
 *
 *  Created by hailong zhang on 10-10-5.
 *  Copyright 2010 hailongz. All rights reserved.
 *
 */

#ifndef HMAP_H
#define HMAP_H

#include "hmem.h"

#define  MAP_CAPACITY_DEFAULT	20

#ifdef __cplusplus
extern "C" {
#endif
	
    typedef struct _map_t{
        hint32 count;
    } * hmap_t;
    
	typedef huintptr (*hash_code_t)(hany key,InvokeTickDeclare);
	
	typedef hbool (*equal_t)(hany  key1,hany key2,InvokeTickDeclare);
	
	typedef void (*map_each_t)(hmap_t map, hany key,hany value,hany arg0,hany arg1,InvokeTickDeclare);
	
	huintptr hash_code_str(hany ,InvokeTickDeclare);
	
	huintptr hash_code_any(hany ,InvokeTickDeclare);
	
	hbool equal_str(hany ,hany,InvokeTickDeclare);
	
	hbool equal_any(hany ,hany ,InvokeTickDeclare);
	
	
	hmap_t map_alloc(hint32 capacity,hash_code_t hash_code ,equal_t equal,InvokeTickDeclare);
	
	void map_dealloc(hmap_t map,InvokeTickDeclare);
	
	hany map_put(hmap_t map,hany key,hany value,InvokeTickDeclare);
	
	hany map_get(hmap_t map,hany key,InvokeTickDeclare);
	
	hany map_remove(hmap_t map,hany key,InvokeTickDeclare);
	
	hany map_get_and_exist(hmap_t map,hany key,hbool * exist,InvokeTickDeclare);
	
	hany map_get_by_defalut(hmap_t map,hany key,hany defaultValue,InvokeTickDeclare);
	
	void map_each(hmap_t map,map_each_t each,hany arg0,hany arg1,InvokeTickDeclare);
	
	void map_clear(hmap_t map,InvokeTickDeclare);
	
	hint32 map_count(hmap_t map,InvokeTickDeclare);
    
    
#define map_alloc(b, c)	map_alloc( MAP_CAPACITY_DEFAULT,(b), (c),InvokeTickArg)
    
#define map_dealloc(a) map_dealloc((a),InvokeTickArg)
	
#define map_put(a,b,c) map_put((a),(b),(c),InvokeTickArg)
	
#define map_get(a,b) map_get((a),(b),InvokeTickArg)
	
#define map_remove(a,b) map_remove((a),(b),InvokeTickArg)
	
#define map_get_and_exist(a,b,c) map_get_and_exist((a),(b),(c),InvokeTickArg)
	
#define map_get_by_defalut(a,b,c) map_get_by_defalut((a),(b),(c),InvokeTickArg)
	
#define map_each(a,b,c,d) map_each((a),(b),(c),(d),InvokeTickArg)
	
#define map_clear(a) map_clear((a),InvokeTickArg)
	
#define map_count(a) map_count((a),InvokeTickArg)
	
#ifdef __cplusplus
}
#endif

#endif
