#include"Envelope.h"

ifstream& operator>>(ifstream& inStream, Envelope& envelope){
	inStream >> envelope.id;
	inStream.get();
	getline(inStream, envelope.title);
	return inStream;
}

ofstream& operator<< (ofstream& outStream, const Envelope& envelope){
	outStream << envelope.id << " " << envelope.title<< endl;
	return outStream;
}

ostream& operator<< (ostream& outStream, const Envelope& envelope){
	outStream.unsetf(ios::floatfield);
	outStream.setf(ios::showpoint);
	outStream.setf(ios::fixed);
	outStream.precision(2);
	outStream << envelope.id << " " << envelope.title<< endl;
	return outStream;
}