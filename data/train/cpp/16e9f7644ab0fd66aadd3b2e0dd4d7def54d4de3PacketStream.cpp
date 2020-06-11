#include "PacketStream.h"


PacketStream::PacketStream(void)
{
}


PacketStream::~PacketStream(void)
{
}

////Input and Output to streams from char array//
void PacketStream::fromCharArray(char* arrayIn)
{
	//clear previous contents of inputStream
	inputStream.str("");
	//place recieved contents to inputStream
	inputStream.str(arrayIn);
}
void PacketStream::toCharArray(char* arrayIn)
{
	//Create a string variable
	string s = outputStream.str();
	memcpy(arrayIn, s.c_str(), s.length());
	outputStream.str("");	
}
///////////////////////////////////////////////

////////////Write and Read Ints////////////////
void PacketStream::writeInt(int x)
{
	outputStream << x << " ";
}
void PacketStream::readInt(int &x)
{
	inputStream >> x;
}
///////////////////////////////////////////////

////////////Write and Read Floats////////////////
void PacketStream::writeFloat(float x)
{
	outputStream << x << " ";
}
void PacketStream::readFloat(float &x)
{
	inputStream >> x;
}
///////////////////////////////////////////////

////////////Write and Read Bools////////////////
void PacketStream::writeBool(bool x)
{
	outputStream << x << " ";
}
void PacketStream::readBool(bool& x)
{
	inputStream >> x;
}
///////////////////////////////////////////////

////////////Write and Read Strings////////////////
void PacketStream::writeString(string x)
{
	outputStream << x << " ";
}
void PacketStream::readString(string& x)
{
	inputStream >> x;
}
///////////////////////////////////////////////