#ifndef OUTPUTSTREAM_H
#define OUTPUTSTREAM_H

#include "IOException.h"
#include "../lang/Types.h"
#include <cstdio>

namespace ycg {

class OutputStream {
public:
	OutputStream();
	OutputStream(const char* fileName, const char* mode = "w");
	virtual ~OutputStream();
	void close();
	friend OutputStream& operator << (OutputStream& os, int32 i);
	friend OutputStream& operator << (OutputStream& os, uint32 i);
	friend OutputStream& operator << (OutputStream& os, double d);
	friend OutputStream& operator << (OutputStream& os, char ch);
	friend OutputStream& operator << (OutputStream& os, const char* str);
private:
	OutputStream(const OutputStream& orig);
	OutputStream(OutputStream&& orig);
	OutputStream& operator = (const OutputStream& orig);
	OutputStream& operator = (OutputStream&& orig);
protected:
	FILE* fp;
};

OutputStream& operator << (OutputStream& os, int32 i);
OutputStream& operator << (OutputStream& os, uint32 i);
OutputStream& operator << (OutputStream& os, double d);
OutputStream& operator << (OutputStream& os, char ch);
OutputStream& operator << (OutputStream& os, const char* str);

} //~ namespace ycg

#endif /* OUTPUTSTREAM_H */
