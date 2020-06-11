#include "ChunksManager.hpp"
#include <malloc.h>

ChunkManager::ChunkManager () {

	maxFltlinesSupported = 5;
	fltInUse = 0;
}

ChunkManager::~ChunkManager () {

	for (NV_INT32 i = 0; i < fltInUse; i++) {
		free (chunks[i].maxRecord);
		free (chunks[i].minRecord);
	}
}


void ChunkManager::SetMaxFltLinesSupported (NV_INT32 toSupport) {

	maxFltlinesSupported = toSupport;
}


Chunk * ChunkManager::RegisterFlightline (QString name) {

	
	NV_INT32 foundIndex = FindFlightLineIndex (name);

	if (foundIndex >= 0) return &(chunks[foundIndex]);
	else {		
		
		Chunk * newChunk = FillChunk (name);		

		if (newChunk != NULL) {
			
			AddFlightlineChunk (newChunk);			

			if (fltInUse != maxFltlinesSupported) fltInUse++;

			delete newChunk;
			
			return &(chunks[0]);
		}	
		
		return NULL;
	}
}


void ChunkManager::AddFlightlineChunk (Chunk * chunk) {

	for (NV_INT32 i = (fltInUse - 1); i >= 0; i--) {

		if (i == (maxFltlinesSupported - 1)) continue;
		else chunks[i + 1] = chunks[i];
	}

	chunks[0] = *chunk;
}


NV_INT32 ChunkManager::FindFlightLineIndex (QString name) {

	for (NV_INT32 i = 0; i < fltInUse; i++) 
		if (chunks[i].name == name) return i;

	return -1;
}


Chunk * ChunkManager::FillChunk (QString name) {

	QFileInfo fileInfo (name);
	QDir dir = fileInfo.dir();

	QString filePrefix = fileInfo.completeBaseName();
	QString nameFilter = filePrefix + "*.wav";

	QStringList filters;
	
	filters << nameFilter;

	dir.setNameFilters (filters);
	dir.setSorting (QDir::Name);
	dir.setFilter (QDir::Files);

	QStringList matchingFiles = dir.entryList (filters);

	Chunk * newChunk = new Chunk;
	//newChunk = (struct Chunk *) malloc (sizeof (struct Chunk));

	if (newChunk == NULL) {

		fprintf (stderr, "error[FillChunk]:  chunk could not be allocated\n");
		fflush (stderr);

		return NULL;
	}

	newChunk->name = name;
	newChunk->numChunks = matchingFiles.size ();

	newChunk->maxRecord = (NV_INT64 *) malloc (sizeof (NV_INT64) * newChunk->numChunks);
	newChunk->minRecord = (NV_INT64 *) malloc (sizeof (NV_INT64) * newChunk->numChunks);

	if (newChunk->maxRecord == NULL || newChunk->minRecord == NULL) {

		fprintf (stderr, "error[FillChunk]: max or min record of Waveform chunk memory could not be allocated.\n");
		fflush (stderr);

		delete newChunk;

		return NULL;
	}	

	for (NV_INT32 i = 0; i < matchingFiles.size (); i++) {
		
		QString fileName = dir.absolutePath() + "/" + matchingFiles.at(i);		

		NV_BOOL success = ProcessWFFile (fileName, newChunk);

		if (!success) {

			fprintf (stderr, "error[FillChunk]:  problem opening waveform file\n");
			fflush (stderr);

			delete newChunk;
			return NULL;
		}
	}	

	return newChunk;
}



NV_BOOL ChunkManager::ProcessWFFile (QString fileName, Chunk * chunk) {

	for (NV_INT32 i = 0; i < chunk->numChunks; i++) { 

		FILE * fp;
		  
   	    fp = fopen (fileName.toAscii(), "rb");

		if (fp == NULL) {

		  fprintf (stderr, " could not open chunky file %s\n", qPrintable (fileName));
		  fflush (stderr);

		  return false;
		}

		fseek (fp, 0, SEEK_END);
		NV_INT64 eof = ftell (fp);

		NV_INT64 numRecords = eof / 1000;

		if (i == 0) {
		  chunk->minRecord[i] = 0;
		  chunk->maxRecord[i] = numRecords - 1;
		}
		else {
		  chunk->minRecord[i] = chunk->maxRecord[i - 1] + 1;
		  chunk->maxRecord[i] = chunk->minRecord[i] + numRecords - 1;
		}		

		fclose (fp);
	}

        return true;
}
