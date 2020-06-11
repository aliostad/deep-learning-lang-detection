/*
 *  stack.h
 *   C Library
 *
 *  Created by hailong zhang on 10-8-5.
 *  Copyright 2010 hailong. All rights reserved.
 *
 */


#ifndef HSTACK_H
#define HSTACK_H

#include "hmem.h"

#ifdef __cplusplus
extern "C" {
#endif
	
	HANDLER(hstack_t);

	hstack_t stack_alloc(InvokeTickDeclare);
	
	void stack_dealloc(hstack_t hStack,InvokeTickDeclare);
	
	void stack_push(hstack_t hStack,hany item,InvokeTickDeclare);
	
	hany stack_pop(hstack_t hStack,InvokeTickDeclare);
	
	hany stack_peek(hstack_t hStack,InvokeTickDeclare);
	
	hint32 stack_number(hstack_t hStack,InvokeTickDeclare);
	
	void stack_clear(hstack_t hStack,InvokeTickDeclare);
    
#define stack_alloc() stack_alloc(InvokeTickArg)
	
#define stack_dealloc(a) stack_dealloc((a),InvokeTickArg)
	
#define stack_push(a,b) stack_push((a),(b),InvokeTickArg)
	
#define stack_pop(a) stack_pop((a),InvokeTickArg)
	
#define stack_peek(a) stack_peek((a),InvokeTickArg)
	
#define stack_number(a) stack_number((a),InvokeTickArg)
	
#define stack_clear(a) stack_clear((a),InvokeTickArg)
    
#ifdef __cplusplus
}
#endif

#endif

