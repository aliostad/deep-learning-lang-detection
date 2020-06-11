#include "reader/reader.h"
#include "chunkReader/chunkReader.h"

void printByteArray(byteArray input,size_t length){
	for(size_t i = 0; i < length; i++){
		printf("0x%X\n",input[i]);
	}
}

int main(){
	CReader myReader("/Users/kkirby/Downloads/Rct_08__Katies_Dreamland.SC6");
	CChunkReader myChunkReader(&myReader);
	CChunkReader::CByteArrayContainer * myBytes = myChunkReader.readChunk();
	free(myBytes);
	myBytes = myChunkReader.readChunk();
	free(myBytes);
	myBytes = myChunkReader.readChunk();
	free(myBytes);
	myBytes = myChunkReader.readChunk();
	free(myBytes);
	myBytes = myChunkReader.readChunk();
	free(myBytes);
	myBytes = myChunkReader.readChunk();
	std::cout << myBytes->length;
	return 0;
}