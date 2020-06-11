/*
 * $Id$
 *
 * Copyright(C) 1998-2008 Satoshi Nakamura
 *
 */

#ifndef __ACTIONINVOKER_H__
#define __ACTIONINVOKER_H__

#include <qs.h>


namespace qmscript {

/****************************************************************************
 *
 * ActionInvokeHelper
 *
 */

template<class T>
class ActionInvokeHelper : public T
{
protected:
	ActionInvokeHelper();
	~ActionInvokeHelper();

public:
	STDMETHOD(invokeAction)(BSTR bstrAction,
							VARIANT arg1,
							VARIANT arg2,
							VARIANT arg3);

private:
	ActionInvokeHelper(const ActionInvokeHelper&);
	ActionInvokeHelper& operator=(const ActionInvokeHelper&);
};

}

#include "actioninvoker.inl"

#endif // __ACTIONINVOKER_H__
