
#include "PacketStream.h"

PacketStream::PacketStream() {

}

void PacketStream::readInt(int &pVal) {

	inputStream >> pVal;
}

void PacketStream::writeInt(int pVal) {

	outputStream << pVal << " ";
}

void PacketStream::readFloat(float &pVal) {

	inputStream >> pVal;
}

void PacketStream::writeFloat(float pVal) {

	outputStream << pVal << " ";
}

void PacketStream::readBool(bool &pVal) {

	inputStream >> pVal;
}

void PacketStream::writeBool(bool pVal) {

	outputStream << pVal << " ";
}

void PacketStream::readChar(char* pVal) {

	inputStream >> pVal;
}

void PacketStream::writeChar(char pVal) {

	outputStream << pVal;
}

void PacketStream::toCharArray(char* arrayIn) {  

	string s = outputStream.str();
	memcpy(arrayIn, s.c_str(),s.length());
	outputStream.str("");
}

void PacketStream::fromCharArray(char* arrayIn) {    

	inputStream.str(""); // clear the old stream
	inputStream.str(arrayIn);//populate inputStream
}

PacketStream::~PacketStream() {


}

