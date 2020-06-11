/*
 *  url.h
 *  C Library
 *
 *  Created by hailong zhang on 10-7-30.
 *  Copyright 2010 hailongz. All rights reserved.
 *
 */


#ifndef HURL_H
#define HURL_H

#include "hmem.h"
#include "hbuffer.h"
#include "hlist.h"

#ifdef __cplusplus
extern "C" {
#endif
	
	HANDLER(hurl_t)

	#define URL_PORT_AUTO	-1
	
	#define URL_PROTOCOL	0x0001
	#define URL_DOMAIN		0x0002
	#define URL_PORT		0x0004
	#define URL_PATH		0x0010
	#define URL_QUERY		0x0020
	#define URL_TOKEN		0x0040

	#define URL_ALL			(URL_PROTOCOL | URL_DOMAIN | URL_PORT | URL_PATH | URL_QUERY | URL_TOKEN)

	hurl_t url_alloc(hcchar *url,hint32 defaultPort, InvokeTickDeclare);

	void url_dealloc(hurl_t url, InvokeTickDeclare);

	hcchar * url_protocol(hurl_t url, InvokeTickDeclare);

	hcchar * url_domain(hurl_t url, InvokeTickDeclare);

	hint32 url_port(hurl_t url, InvokeTickDeclare);

	struct in_addr  url_domain_resolv(hurl_t url, InvokeTickDeclare);

	hcchar * url_path(hurl_t url, InvokeTickDeclare);

	hcchar * url_query(hurl_t url, InvokeTickDeclare);

	hcchar * url_token(hurl_t url, InvokeTickDeclare);

	hcchar * url_mask(hurl_t url,int mark, InvokeTickDeclare);
	
	hlist_t url_param_names(hurl_t url, InvokeTickDeclare);
	
	hcchar * url_param(hurl_t url,hcchar * name, InvokeTickDeclare);
	
	void url_encode(hcchar *url,hbuffer_t buffer, InvokeTickDeclare);
	
	void url_decode(hcchar *url,hbuffer_t buffer, InvokeTickDeclare);
    
    struct in_addr url_resolv(const char *domain);
    
    
    
#define url_alloc(a,b) url_alloc((a),(b),InvokeTickArg)
    
#define url_dealloc(a) url_dealloc((a),InvokeTickArg)
    
#define url_protocol(a) url_protocol((a),InvokeTickArg)
    
#define url_domain(a) url_domain((a),InvokeTickArg)
    
#define url_port(a) url_port((a),InvokeTickArg)
    
#define url_domain_resolv(a) url_domain_resolv((a),InvokeTickArg) 
    
#define url_path(a) url_path((a),InvokeTickArg)
    
#define url_query(a) url_query((a),InvokeTickArg)
    
#define url_token(a) url_token((a),InvokeTickArg)
    
#define url_mask(a,b) url_mask((a),(b),InvokeTickArg)
	
#define url_param_names(a) url_param_names((a),InvokeTickArg)
	
#define url_param(a,b) url_param((a),(b),InvokeTickArg)
	
#define url_encode(a,b) url_encode((a),(b),InvokeTickArg)
	
#define url_decode(a,b) url_decode((a),(b),InvokeTickArg)
	
#ifdef __cplusplus
}
#endif
		
#endif
