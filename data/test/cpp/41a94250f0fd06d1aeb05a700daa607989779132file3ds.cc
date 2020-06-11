//============================================================================
// file3ds.cc:
// Copyright(c) 1995 Cave Logic Studios / PF.Magic
// By Kevin T. Seghetti
//============================================================================
/* Documentation:

	Abstract:

	History:
			Created	05-16-95 01:07pm Kevin T. Seghetti

	Class Hierarchy:
			none

	Dependancies:
	Restrictions:
	Example:
*/
//============================================================================

#include "global.hpp"

#include "file3ds.hpp"
//#include "pigtool.h"
#include "hdump.hpp"


#define TRUE (1==1)
#define FALSE (1==0)

//============================================================================

QFile3ds::QFile3ds(SceneEnumProc* theScene)
{
#ifdef DISABLED
   databasefile = OpenFile3ds(filename, "rw");
   PRINT_ERRORS_EXIT(stderr);
   assert(databasefile);

   db = NULL;
   InitDatabase3ds(&db);
   PRINT_ERRORS_EXIT(stderr);
   assert(db);

   CreateDatabase3ds(databasefile, db);
   PRINT_ERRORS_EXIT(stderr);
#endif	// DISABLED

	_theScene = theScene;
}

//============================================================================

QFile3ds::~QFile3ds()
{
#ifdef DISABLED

   ReleaseDatabase3ds(&db);
   PRINT_ERRORS_EXIT(stderr);

   CloseFile3ds(databasefile);
   PRINT_ERRORS_EXIT(stderr);
#endif // DISABLED
}

//============================================================================

void
QFile3ds::DumpMeshes(ostream& output)
{
#ifdef DISABLED

    mesh3ds *mesh = NULL;
	AppDataChunk* meshChunk;

	// read in meshes
	ulong numElem = GetMeshCount3ds(db);
	PRINT_ERRORS_EXIT(stderr);
	DBSTREAM3( cstats << "There are " << numElem << " meshes" << endl; )
	for (ulong i = 0; i < numElem; i++)
	 {
		GetMeshByIndex3ds(GetDatabase(), i, &mesh);
		PRINT_ERRORS_EXIT(stderr);

		DBSTREAM3( cprogress << "processing mesh " << mesh->name << endl; )
		if(mesh->procdata)
		 {
			DBSTREAM3( cstats << "Has Procdata at address " << mesh->procdata << " of size " << mesh->procsize << endl; )
			HDump(mesh->procdata,(uint32)mesh->procsize,0);
		 }
		meshChunk = FindMeshChunk(mesh->name);
		if(meshChunk)
		 {
			DumpChunk3DS(meshChunk,0,FALSE,mesh->name);
		 }
	 }
#endif // DISABLED
}

//============================================================================

//database3ds*
//QFile3ds::GetDatabase(void) const
//{
//	assert(db);
//	return(db);
//}

//============================================================================

//void
//LoadFileData(FILE* fp,void* buffer, ulong3ds position, ulong3ds size)
//{
//	ulong3ds curPos = ftell(fp);
//	fseek(fp,position,SEEK_SET);
//	fread(buffer,size,1,fp);
//	fseek(fp,curPos,SEEK_SET);
//}

//============================================================================

void
QFile3ds::LoadChunkData(AppDataChunk* chunk)
{
//	LoadFileData(databasefile->file,(void*)&chunkBuffer,chunk->position, chunk->size);
}

//============================================================================

void
QFile3ds::DumpChunk3DS(AppDataChunk* chunk, int indent, short dumpSib, const char* name)
{

//	cout << "AppDataChunk dump:" << endl;

	cout << "chunktag3ds: $" << hex << setw(4) << setfill('0') << chunk->tag << endl;
	cout << "chunk size: $" << hex << setw(4) << setfill('0') << chunk->size << endl;
	cout << "Chunk data: " << endl;

	assert(chunk->size < CHUNKBUFFERSIZE);
	LoadChunkData(chunk);
	HDump(chunkBuffer.chunkData,chunk->size,indent);

// now dump any children
	 if(chunk->children)
	  {
		cout << "Child of " << name << endl;
		DumpChunk3DS(chunk->children,indent+1,TRUE,name);
	  }

// now dump any siblings (unless at top level)
	if(dumpSib && chunk->sibling)
	 {
		cout << "Sibling of " << name << endl;
		DumpChunk3DS(chunk->sibling,indent,TRUE,name);
	 }
	cout << dec;
}

//============================================================================
// find the 3ds chunk for named mesh

AppDataChunk*
QFile3ds::FindMeshChunk(const char* name) const
{
	chunklistentry3ds* cle3ds;
	AppDataChunk* c3ds;
//	cout << "looking for " << %s << "...";

	for(int index=0;index<db->objlist->count;index++)
	 {
		cle3ds = &db->objlist->list[index];

		if(!strcmp(name,cle3ds->name))
		 {
			c3ds = cle3ds->chunk;
			DBSTREAM3( cstats << "QFile3ds::FindMeshChunk: Found " << cle3ds->name << endl; )

//			cout << "Dump of " << cle3ds->name << endl;
//			HDump(cle3ds->chunk,100,0);
			return(c3ds);
		 }
	 }
	cerror << "Error: object " << name << " not found" << endl;
	assert(0);
	return(NULL);
}

//============================================================================
// returns AppDataChunk* if found, NULL if not

AppDataChunk*
QFile3ds::FindXDataChunk(AppDataChunk* mesh) const
{
	AppDataChunk* chunk;

	assert(mesh);
	assert(mesh->tag == NAMED_OBJECT);

	chunk = ChunkFindChild(mesh,N_TRI_OBJECT);
	assert(chunk);
	chunk = ChunkFindChild(chunk,XDATA_SECTION);
	return(chunk);
}

//============================================================================

AppDataChunk*
QFile3ds::FindNamedXDataChunk(AppDataChunk* xDataChunk,const char* name)
{
	AppDataChunk* dataChunk;
	AppDataChunk* nameChunk;

	assert(xDataChunk);
	assert(xDataChunk->tag == XDATA_SECTION);

	dataChunk = ChunkFindChild(xDataChunk,XDATA_ENTRY);

	DBSTREAM3( cdebug << "File3ds::FindNamedXDataChunk: looking in chunk <" << xDataChunk << "> for <" << name << ">" << endl; )
	while(dataChunk)
	 {
		assert(dataChunk->tag == XDATA_ENTRY);
		if(dataChunk->children)
		 {
			DBSTREAM3( cdebug << "  find child" << endl; )
			nameChunk = ChunkFindChild(dataChunk,XDATA_APPNAME);
			if(nameChunk)
			 {
				DBSTREAM3( cdebug << "  found child with tag of <" << hex << nameChunk->tag << ">, contains " << (const char*)&chunkBuffer.chunkData << endl; )
				LoadChunkData(nameChunk);
			 	if(!strncmp(name,(const char*)&chunkBuffer.chunkData,strlen(name)))
				 {
					DBSTREAM3( cdebug << "  desired chunk found! " << (const char*)&chunkBuffer.chunkData << endl; )
					return(dataChunk);
				 }
			 }
		 }
		DBSTREAM3( cdebug << "  find sibling" << endl; )
		dataChunk = ChunkFindSibling(dataChunk,XDATA_ENTRY);
		DBSTREAM3( if(dataChunk) )
			DBSTREAM3( cdebug << "  found sibling with tag of " << hex << dataChunk->tag << endl; )
	 }

	return(dataChunk);
}

//============================================================================

ulong3ds
QFile3ds::GetChunkDataSize(AppDataChunk* chunk) const
{
	return(chunk->size);
}

//============================================================================

void
QFile3ds::GetChunkData(AppDataChunk* chunk,char* destBuffer) const
{
	int fudge = offsetof(_chunkOnDisk,chunkData);
	LoadFileData(databasefile->file,(void*)destBuffer,chunk->position+fudge, chunk->size);
}

//============================================================================
// search self and all siblings for first chunk of type tag, if found, return ptr to it,
// otherwise return NULL

AppDataChunk*
ChunkFindSelfOrSibling(AppDataChunk* chunk, chunktag3ds tag)
{
	assert(chunk);
	assert(tag);
	 while(chunk && (chunk->tag != tag))
		chunk = chunk->sibling;

	return(chunk);
}

//============================================================================
// search all siblings for first chunk of type tag, if found, return ptr to it,
// otherwise return NULL

AppDataChunk*
ChunkFindSibling(AppDataChunk* chunk, chunktag3ds tag)
{
	assert(chunk);
	assert(tag);

	chunk = chunk->sibling;
	while(chunk && (chunk->tag != tag))
		chunk = chunk->sibling;

	return(chunk);
}

//============================================================================

AppDataChunk*
ChunkFindChild(AppDataChunk* chunk, chunktag3ds tag)
{
	assert(chunk);
	assert(chunk->children);
	assert(tag);
	return(ChunkFindSelfOrSibling(chunk->children,tag));
}

//============================================================================
