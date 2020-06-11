/****************************************************************************/
/*                                                                          */
/*      文件名:    BLZChunkFile.cpp                                         */
/*      创建日期:  2010年02月09日                                           */
/*      作者:      Sagasarate                                               */
/*                                                                          */
/*      本软件版权归Sagasarate(sagasarate@sina.com)所有                     */
/*      你可以将本软件用于任何商业和非商业软件开发，但                      */
/*      必须保留此版权声明                                                  */
/*                                                                          */
/****************************************************************************/
#include "StdAfx.h"

namespace D3DLib{

CBLZChunkFile::CBLZChunkFile(void)
{
	m_pData=NULL;
	m_DataSize=0;
	m_IsSelfRelease=false;
}

CBLZChunkFile::~CBLZChunkFile(void)
{
	Close();
}

BOOL CBLZChunkFile::Load(IFileAccessor * pFile)
{
	Close();

	UINT DataSize=(UINT)pFile->GetSize();
	if(DataSize<sizeof(BLZ_CHUNK_HEADER))
		return FALSE;
	BYTE * pData=new BYTE[DataSize];	
	pFile->Seek(0,IFileAccessor::seekBegin);
	if(pFile->Read(pData,DataSize)<DataSize)
	{
		delete[] pData;
		return FALSE;
	}

	m_IsSelfRelease=true;
	return Load(pData,DataSize);
}

BOOL CBLZChunkFile::Load(BYTE * pData,UINT DataSize)
{
	m_pData=pData;
	m_DataSize=DataSize;
	BLZ_CHUNK_HEADER * pChunk=(BLZ_CHUNK_HEADER *)m_pData;
	UINT ChunkSize=m_DataSize;
	while(pChunk->ChunkSize+sizeof(BLZ_CHUNK_HEADER)<=ChunkSize)
	{		
		CChunkList * pChunkList=m_Chunks.New(pChunk->ChunkID);
		if(pChunkList)
		{
			pChunkList->Add(pChunk);
		}
		ChunkSize-=pChunk->ChunkSize+sizeof(BLZ_CHUNK_HEADER);
		if(ChunkSize<sizeof(BLZ_CHUNK_HEADER))
		{
			break;
		}
		pChunk=(BLZ_CHUNK_HEADER *)((BYTE *)pChunk+sizeof(BLZ_CHUNK_HEADER)+pChunk->ChunkSize);
	}

	void * Pos=m_Chunks.GetFirstObjectPos();
	while(Pos)
	{
		UINT Key;
		CChunkList * pChunkList=m_Chunks.GetNextObject(Pos,Key);
		//CEasyString Name;
		//Name.SetString((*pChunkList)[0]->ChunkName,4);
		//PrintSystemLog(0,"Chunk %s=%u",
		//	(LPCTSTR)Name,pChunkList->GetCount());
	}
	return TRUE;
}

void CBLZChunkFile::Close()
{
	m_Chunks.Clear();
	if(m_IsSelfRelease)
	{
		SAFE_DELETE(m_pData);		
	}
	m_pData=NULL;
	m_DataSize=0;
}


CBLZChunkFile::CChunkList * CBLZChunkFile::GetChunks(UINT ChunkID)
{
	return m_Chunks.Find(ChunkID);
}
	
BLZ_CHUNK_HEADER * CBLZChunkFile::GetFirstChunk(UINT ChunkID)
{
	CChunkList * pChunkList=m_Chunks.Find(ChunkID);
	if(pChunkList)
	{
		if(pChunkList->GetCount())
		{
			return (*pChunkList)[0];
		}
	}
	return NULL;
}

BLZ_CHUNK_HEADER * CBLZChunkFile::GetChunkByOffset(UINT ChunkID,UINT Offset)
{
	if(Offset<m_DataSize-sizeof(BLZ_CHUNK_HEADER))
	{
		BLZ_CHUNK_HEADER * pChunk=(BLZ_CHUNK_HEADER *)(m_pData+Offset);
		if(pChunk->ChunkID==ChunkID)
		{
			return pChunk;
		}
	}
	return NULL;
}


}