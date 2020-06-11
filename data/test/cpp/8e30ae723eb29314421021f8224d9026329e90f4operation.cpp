#include "stdafx.h"
#include "operation.hpp"

namespace tc {

operation::operation(raw_handler handler)
	: _raw_handler(handler)
{
}

operation::operation(const operation & rhs)
	: _raw_handler(rhs._raw_handler)
{
}
	
operation & operation::operator=(const operation & rhs)
{
	_raw_handler = rhs._raw_handler;
	return *this;
}

operation & operation::operator=(const raw_handler handler)
{
	_raw_handler = handler;
	return *this;
}

operation::~operation(void)
{
}
	
void operation::operator()(void)
{
	if (_raw_handler)
		_raw_handler(this);
}

	
}