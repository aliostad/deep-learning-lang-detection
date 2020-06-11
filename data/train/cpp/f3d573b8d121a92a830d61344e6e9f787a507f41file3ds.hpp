//============================================================================
// file3ds.hp:
// Copyright(c) 1995 Cave Logic Studios / PF.Magic
// By Kevin T. Seghetti
//============================================================================
/* Documentation:

	Abstract:

	History:
			Created	05-16-95 01:07pm Kevin T. Seghetti

	Class Hierarchy:
			none

*/
//============================================================================
// use only once insurance
#ifndef _FILE3DS_HP
#define _FILE3DS_HP

//============================================================================

#include "global.hpp"
#include "scene.hpp"
#include <iostream.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>
#include <iomanip.h>


//============================================================================
#define CHUNKBUFFERSIZE 30000

class QFile3ds
{
public:
	QFile3ds(SceneEnumProc* theScene);
	~QFile3ds();
//	database3ds* GetDatabase(void) const;
	void DumpMeshes(ostream& output);
	AppDataChunk* FindMeshChunk(const char* name) const;		// lookup mesh chunk for named mesh
	AppDataChunk* FindXDataChunk(AppDataChunk* mesh) const;			// lookup xdata chunk section of mesh chunk
	AppDataChunk* FindNamedXDataChunk(AppDataChunk* xDataChunk,const char* name);	// find a particular xdata chunk in the xdata chunk
	void DumpChunk3DS(AppDataChunk* chunk, int indent, short dumpSib, const char* name);

	long GetChunkDataSize(AppDataChunk* chunk) const;
 	void GetChunkData(AppDataChunk* chunk,char* destBuffer) const;
private:
	void LoadChunkData(AppDataChunk* chunk);
	QFile3ds();				// prevent construction without parameters
	SceneEnumProc* _theScene;
//	database3ds *db;
//	file3ds *databasefile;

//#pragma pack(1)
//	struct _chunkOnDisk			// needs to match chunk on disk format
//	 {
//		chunktag3ds tag;
//		ulong size;
//		char chunkData[CHUNKBUFFERSIZE];
//	 };
//#pragma pack()
//	_chunkOnDisk chunkBuffer;

};

//const int chunkHeaderSize = sizeof(chunktag3ds) + sizeof(ulong3ds);

//============================================================================
// chunk manipulators

#ifdef DISABLED
AppDataChunk*
ChunkFindSibling(AppDataChunk* chunk, chunktag3ds tag);

AppDataChunk*
ChunkFindSelfOrSibling(AppDataChunk* chunk, chunktag3ds tag);


AppDataChunk*
ChunkFindChild(AppDataChunk* chunk, chunktag3ds tag);

#endif	// DISABLED
//============================================================================
#endif
//============================================================================
