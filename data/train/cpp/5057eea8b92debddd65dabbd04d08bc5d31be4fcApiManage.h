// Copyright(C) 1999-2005 LiuTaoTao，bookaa@rorsoft.com

//	CApiManage.h
#ifndef __ApiManage__H
#define __ApiManage__H
#pragma once
#include <list>
#include "DataType.h"

class Api
{
public:
    int 	m_stack_purge;	//7 for invalid
	ea_t	m_address;
	char name[80];

	FuncType* m_functype;

    Api();
    ~Api(){}
};


class ApiManage
{
    typedef	std::list<Api*> lApi;
	static ApiManage *s_self;
    lApi	m_apilist;
private:
    ApiManage();
    ~ApiManage();
public:
    static ApiManage *get();

	bool	new_api(ea_t address,int stacksub);
	Api*	get_api(ea_t address);
	void New_ImportAPI(const std::string & pstr, uint32_t apiaddr);
};

#endif // __ApiManage__H
