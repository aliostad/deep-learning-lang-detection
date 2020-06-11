/*
-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

made by ALACN
alacn@bol.com.br
uhahaa@msn.com
http://www.strategyplanet.com/populous

-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-
*/


#include <windows.h>
#include <stdio.h>
#include <stdlib.h>
#include "3ds.h"




DWORD _3dsCalcChunkSize(CHUNK *root)
{
	DWORD dwSize = sizeof(CHUNK_HDR);

	if(root->data) dwSize += root->data_size;

	CHUNK *chunk = root->Child;
	if(chunk) do
	{
		dwSize += _3dsCalcChunkSize(chunk);
		chunk = chunk->Next;
	}
	while(chunk != root->Child);

	root->hdr.length = dwSize;

	return dwSize;
}


void _3dsDestroyChunk(CHUNK *root)
{
	if(root->data)
	{
		free(root->data);
		root->data = 0;
	}

	while(root->Child)
	{
		CHUNK *child = root->Child;
		UNLINK(root->Child, child);
		_3dsDestroyChunk(child);
		delete child;
	}
}


bool _3dsWriteChunk(HANDLE h, CHUNK *root)
{
	DWORD dwW;

	dwW = 0;
	WriteFile(h, &root->hdr, sizeof(CHUNK_HDR), &dwW, 0);
	if(dwW != sizeof(CHUNK_HDR)) return false;

	dwW = 0;
	WriteFile(h, root->data, root->data_size, &dwW, 0);
	if(dwW != root->data_size) return false;

	CHUNK *chunk = root->Child;
	if(chunk) do
	{
		if(!_3dsWriteChunk(h, chunk)) return false;
		chunk = chunk->Next;
	}
	while(chunk != root->Child);

	return true;
}


bool _3dsWriteFile(char *name, CHUNK *root)
{
	HANDLE h = CreateFile(name, GENERIC_READ | GENERIC_WRITE, 0, 0, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, 0);
	if(h == INVALID_HANDLE_VALUE) return false;

	_3dsCalcChunkSize(root);

	if(!_3dsWriteChunk(h, root))
	{
		CloseHandle(h);
		return false;
	}

	CloseHandle(h);

	return true;
}
