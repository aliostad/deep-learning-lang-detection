#include "opengta.h"





void Chunk_Loader::Open(const char* FileName) {
	Data = fopen(FileName, "rb");
	if (Data) {
		fseek(Data,0,2); fileSize = ftell(Data); fseek(Data,0,0);
	
		strncpy(fileName,FileName,255);
		fileName[255] = 0;

		/* Wrapper for fread which logs an error if the expected amount
		 * of bytes couldn't be read
		 */
		#define FREAD(dest, size, times, src)				\
		{								\
			size_t const bytes_expected = (size) * (times);		\
			size_t const bytes_read = fread(			\
				(dest), (size), (times), (src));		\
										\
			if (bytes_expected != bytes_read) {			\
				logWrite("Expected to read %d (%d * %d) bytes from %s into %s but could only read %d bytes in %s:%d (%s)",								\
					bytes_expected, (size), (times),	\
					FileName, #dest,			\
					bytes_read,				\
					__FILE__, __LINE__, __func__		\
				);						\
			}							\
		}								\

		FREAD(fileFormat, 1, 4, Data);
		FREAD(&chunkSize, 4, 1, Data);
		FREAD(&fileVersion, 4, 1, Data);
		#undef FREAD

		chunkPos = 4;
		chunkSize = 4;
		chunkHeader[0] = 0;
	} else {
		chunkSize = 0;
		chunkPos = 0;
	}
}

void Chunk_Loader::Close() {
	if (Data) fclose(Data);
}

bool Chunk_Loader::IsFileFormat(const char FormatID[4], uint FormatVersion) {
	if ((Data) && ((strncmp(fileFormat,FormatID,4) == 0) && (fileVersion == FormatVersion))) {
		return true;
	} else return false;

}

bool Chunk_Loader::IsChunk(const char ChunkID[4]) {
	if ((Data) && (strncmp(chunkHeader,ChunkID,4) == 0)) {
		return true;
	} else return false;
}

bool Chunk_Loader::ReadChunk() {
	if (Data) {
		fseek(Data,chunkSize-chunkPos,1); //Skip last chunk

		if (!fread(chunkHeader,1,4,Data)) return false;
		if (!fread(&chunkSize,4,1,Data)) return false;
		chunkPos = 0;

		if (chunkSize > fileSize-ftell(Data)) {
			logError("Corrupted chunk %c%c%c%c (size %d bytes, only %d bytes left in file",
				chunkHeader[0],chunkHeader[1],chunkHeader[2],chunkHeader[3],
				chunkSize,fileSize-ftell(Data));
		}
		if ((chunkHeader[0] < 0x20) || (chunkHeader[0] > 0x7F) ||
			(chunkHeader[1] < 0x20) || (chunkHeader[1] > 0x7F) ||
			(chunkHeader[2] < 0x20) || (chunkHeader[2] > 0x7F) ||
			(chunkHeader[3] < 0x20) || (chunkHeader[3] > 0x7F)) {
			logError("Corrupted chunk header: %c%c%c%c (size %d bytes)",
				chunkHeader[0],chunkHeader[1],chunkHeader[2],chunkHeader[3],
				chunkSize);
		}

		logWritem("\treading chunk %c%c%c%c (%d bytes)",
			chunkHeader[0],chunkHeader[1],chunkHeader[2],chunkHeader[3],
			chunkSize);
		return true;
	} else return false;
}

int Chunk_Loader::Read(void* buf, int sz) {
	if ((Data) && (chunkSize > 0)) {
		int i = 0;
		if (chunkPos + sz > chunkSize) {
			logError("Error while reading %s (chunk %c%c%c%c): exceeded chunk bounds (%d req , %d left)",
				fileName,chunkHeader[0],chunkHeader[1],chunkHeader[2],chunkHeader[3],
				sz, chunkSize - chunkPos);
			return 0;
		}

		if (buf) i = sz*fread(buf,sz,1,Data);
		chunkPos += i;
		return i;
	} else return 0;
}

int Chunk_Loader::ReadString(char buf[256]) {
	unsigned char stringLen;
	int sz = Read(&stringLen,1);
	if (sz) {
		if (stringLen) sz += Read(buf,stringLen);
		buf[stringLen] = '\0';
	} else buf[0] = '\0'; //error when reading chunk file
	return sz;
}

bool Chunk_Loader::IsEndOfChunk() {
	if (chunkPos >= chunkSize) return true;
	return false;
}
