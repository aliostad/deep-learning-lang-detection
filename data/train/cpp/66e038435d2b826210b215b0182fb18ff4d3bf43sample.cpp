#include "sample.h"
#include <finddecryptor/reader.h>
#include <cstring>

namespace detect_similar
{

using namespace find_decryptor;

Sample::Sample(const Sample &sample)
 : MemoryBlock(sample), name(sample.name)
{}

Sample::Sample(string n, string filePath)
 : MemoryBlock()
{
	name = n;
	Reader reader;
	reader.load(filePath.c_str());
	size = reader.size();
	data = new unsigned char[size];
	memcpy((unsigned char *) data, reader.pointer(), size);
	_del_flag = true;
}

Sample::Sample(string n, int ds, unsigned char *d)
 : MemoryBlock(ds, d), name(n)
{}

} //namespace detect_similar
