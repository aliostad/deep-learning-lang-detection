#ifndef MODIFIERSTREAM_H_
#define MODIFIERSTREAM_H_

#include "stream.h"

class ModifyStream : public Stream {

public:
	ModifyStream(Stream* stream): myStream(stream) { }
	virtual ~ModifyStream() { delete myStream; }

public:
	virtual size_t write(const char* ptr, size_t count) { return myStream->write(ptr,count); }
	virtual size_t write(char byte) { return myStream->write(byte);  }
	virtual size_t read(char* ptr, size_t count) { return myStream->read(ptr,count); }
	virtual size_t read(char* byte) { return myStream->read(byte);  }

private:
	Stream* myStream;
};


#endif /* MODIFIERSTREAM_H_ */
