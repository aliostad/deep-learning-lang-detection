//Matthew Wankling
//10/07/06
//FileHeader.cpp


#include "FileHeader.h"
#include <string.h>
#include <iostream>
using namespace std;

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////
CFileHeader::CFileHeader()
{
	chunkID[0] = 'R';
	chunkID[1] = 'I';
	chunkID[2] = 'F';
	chunkID[3] = 'F';

	chunkSize = 0;
	
	format[0] = 'W';
	format[1] = 'A';
	format[2] = 'V';
	format[3] = 'E';

}

void CFileHeader::setChunkSize(long filesize)
{
	chunkSize = filesize;
}

void CFileHeader::displayFileData(void)
{
	cout<< "---------------------------------"<<endl;
	cout << "Chunk ID: \t" ; 
	cout.write(chunkID,4);
	cout << endl<<"Chunk Size: \t" << chunkSize << endl;
	cout << "File Format: \t";
	cout.write(format,4);
	cout<<endl<<"---------------------------------"<<endl;
}