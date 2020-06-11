#ifndef	_OPROS_API_H_
#define	_OPROS_API_H_

#include "ApiTypes.h"
#include "Property.h"

#define	API_SUCCESS			0
#define	API_ERROR			-1
#define	API_NOT_SUPPORTED	-2

class OprosApi
{
public :
	OprosApi(void) { };
	virtual ~OprosApi(void) { };

public:
	virtual int Initialize(Property parameter) { return API_NOT_SUPPORTED; }
	virtual int Finalize(void) { return API_NOT_SUPPORTED; }
	virtual int Enable(void) { return API_NOT_SUPPORTED; }
	virtual int Disable(void) { return API_NOT_SUPPORTED; }
	virtual int SetParameter(Property parameter) { return API_NOT_SUPPORTED; }
	virtual int GetParameter(Property &parameter) { return API_NOT_SUPPORTED; }
};

typedef	OprosApi *(*GET_OPROS_API)();

#endif	//	_OPROS_API_H_