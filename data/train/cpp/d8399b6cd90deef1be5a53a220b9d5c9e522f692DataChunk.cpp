#include "stdafx.h"
#include <vector>
#include "memstream.h"
#include "DataStream.h"
#include "DataChunk.h"

#define new RKT_NEW

namespace xs{

	DataChunk::stChunk::stChunk(uint ui32Type) : m_ui32Type(ui32Type),
		m_ui32ChunkSize(0),
		m_ui32DataSize(0),
		m_pData(0),
		m_pChild(0),
		m_pSibling(0)
	{
	}
DataChunk::stChunk::stChunk(
				 uint ui32Type,
				 uint ui32ChunkSize,
				 uint ui32DataSize,
				 void *pData,
				 stChunk *pChild,
				 stChunk *pSibling)
		:	m_ui32Type(ui32Type),
			m_ui32ChunkSize(ui32ChunkSize),
			m_ui32DataSize(ui32DataSize),
			m_pData(pData),
			m_pChild(pChild),
			m_pSibling(pSibling)
{
}

DataChunk::stChunk::~stChunk()
{
	safeDelete(m_pData);
}

DataChunk::DataChunk() : m_pChunk(0),m_pCurrentChunk(0),m_ui32Offset(0)
{
}

DataChunk::~DataChunk()
{
	Close();
}

void DataChunk::Close_Helper(stChunk *pChunk,void *p)
{
	safeDelete(pChunk);
}

void DataChunk::Close()
{
	RecursiveFunc(&xs::DataChunk::Close_Helper,m_pChunk,0);
	m_pChunk = 0;
	m_pCurrentChunk = 0;
	m_ui32Offset = 0;
}

uint DataChunk::stChunk::GetSize()
{
	//ID + ChunkSize + Data
	return sizeof(m_ui32Type) + sizeof(m_ui32DataSize) + m_ui32DataSize;
}

uint DataChunk::BuildChunkSize(stChunk *pChunk)
{
	uint totalSize = 0;
	while(pChunk)
	{
		uint size = 0;
		stChunk *pSibling = pChunk->m_pSibling;
		stChunk *pChild = pChunk->m_pChild;

		size += pChunk->m_ui32DataSize + CHUNK_MIN_SIZE;

		if(pChild)
		{
			//stChunk *pSibling = pChild->m_pSibling;
			size += BuildChunkSize(pChild);
			//pChild = pSibling;
		}

		pChunk->m_ui32ChunkSize = size;
		totalSize += size;

		pChunk = pSibling;
	}

	return totalSize;
	//RecursiveFunc(BuildChunkSize_Helper,m_pChunk,0);
	//RecursiveFunc(BuildDataSize_Helper,m_pChunk,0);
}

void DataChunk::RecursiveFunc(pRecursiveFunc pFunc,stChunk *pChunk,void *p)
{
	while(pChunk)
	{
		stChunk *pSibling = pChunk->m_pSibling;
		stChunk *pChild = pChunk->m_pChild;

		(this->*pFunc)(pChunk,p);

		if(pChild)
		{
			//stChunk *pSibling = pChild->m_pSibling;
			RecursiveFunc(pFunc,pChild,p);
			//pChild = pSibling;
		}
		pChunk = pSibling;
	}
}
DataChunk::stChunk *DataChunk::SerializeIn_Helper(FILE *fp,uint ui32FPBegin,uint ui32FPEnd,bool bLoadAll,stChunk *pParent,stChunk *pBrother)
{
	if(ui32FPBegin >= ui32FPEnd || !fp)return 0;
	fseek(fp,ui32FPBegin,SEEK_SET);
	if(ui32FPEnd - ui32FPBegin < CHUNK_MIN_SIZE)return 0;

	uint ui32Type;
	uint ui32ChunkSize,ui32DataSize;
	uint ui32FP = ui32FPBegin;

	stChunk *pChunk = 0;
	stChunk *pRet = 0;

	while(ui32FP < ui32FPEnd)
	{
		fread(&ui32Type,sizeof(ui32Type),1,fp);
		ui32FP += sizeof(ui32Type);
		//fread(&ui32ChunkSize,sizeof(ui32ChunkSize),1,fp);
		//ui32FP += sizeof(ui32ChunkSize);
		fread(&ui32DataSize,sizeof(ui32DataSize),1,fp);
		ui32FP += sizeof(ui32DataSize);
		ui32ChunkSize = sizeof(ui32Type) + sizeof(ui32DataSize) + ui32DataSize;

		char *pData = 0;
		if(bLoadAll)
		{
			pData = new char[ui32DataSize];
			fread(pData,ui32DataSize,1,fp);
		}
		else
		{
			fseek(fp,ui32DataSize,SEEK_CUR);
		}
		ui32FP += ui32DataSize;

		pChunk = new stChunk(ui32Type,ui32ChunkSize,ui32DataSize,pData,0,0);

		stChunk *pChild = 0;
		if(ui32FP < ui32FPEnd)
		{
			pChild = SerializeIn_Helper(fp,ui32FP,ui32FP + ui32ChunkSize - pChunk->GetSize(),bLoadAll,pChunk,0);
			ui32FP += ui32ChunkSize - pChunk->GetSize();
		}

		pChunk->m_pChild = pChild;

		if(pParent && !pParent->m_pChild)pParent->m_pChild = pChunk;
		if(pBrother)pBrother->m_pSibling = pChunk;

		pBrother = pChunk;
		if(!pRet)pRet = pChunk;
	}

	return pRet;
}
void DataChunk::SerializeIn(char szFileName[],bool bLoadAll)
{
	Close();

	FILE *fp = fopen(szFileName,"rb");
	if(!fp)return;

	uint ui32Begin = ftell(fp);
	fseek(fp,0,SEEK_END);
	uint ui32End = ftell(fp);

	m_pChunk = SerializeIn_Helper(fp,ui32Begin,ui32End,bLoadAll,0,0);

	fclose(fp);
}

DataChunk::stChunk *DataChunk::SerializeIn_Helper(Stream* data,uint ui32FPBegin,uint ui32FPEnd,stChunk *pParent,stChunk *pBrother)
{
	if(ui32FPBegin >= ui32FPEnd)return 0;
	if(ui32FPEnd - ui32FPBegin < CHUNK_MIN_SIZE)return 0;

	uint ui32Type;
	uint ui32ChunkSize,ui32DataSize;
	uint ui32FP = ui32FPBegin;

	stChunk *pChunk = 0;
	stChunk *pRet = 0;

	while(ui32FP < ui32FPEnd)
	{
		data->read(&ui32Type,sizeof(ui32Type));
		ui32FP += sizeof(ui32Type);
		//fread(&ui32ChunkSize,sizeof(ui32ChunkSize),1,fp);
		//ui32FP += sizeof(ui32ChunkSize);
		data->read(&ui32DataSize,sizeof(ui32DataSize));
		ui32FP += sizeof(ui32DataSize);
		ui32ChunkSize = sizeof(ui32Type) + sizeof(ui32DataSize) + ui32DataSize;

		uint pos = data->getPosition();
		// thunk data is ready for operations.
		this->operateChunk(ui32Type,data,ui32DataSize);
		data->seek(pos + ui32DataSize);
		ui32FP += ui32DataSize;

		pChunk = new stChunk(ui32Type,ui32ChunkSize,ui32DataSize,0,0,0);

		pChunk->m_pChild = 0;

		if(pParent && !pParent->m_pChild)pParent->m_pChild = pChunk;
		if(pBrother)pBrother->m_pSibling = pChunk;

		pBrother = pChunk;
		if(!pRet)pRet = pChunk;
	}

	return pRet;
}

void DataChunk::SerializeIn(Stream* data,uint size)
{
	if(!data)return;

	Close();
	m_pChunk = SerializeIn_Helper(data,0,size,0,0);
}

void DataChunk::SerializeOut_Helper(FILE *fp,stChunk *p)
{
	if(!p)return;
	stChunk *pChunk = p;
	while(pChunk)
	{
		fwrite(&pChunk->m_ui32Type,sizeof(pChunk->m_ui32Type),1,fp);
		uint chunkSize = pChunk->m_ui32ChunkSize - CHUNK_MIN_SIZE;
		fwrite(&chunkSize,sizeof(chunkSize),1,fp);
		//fwrite(&pChunk->m_ui32DataSize,sizeof(pChunk->m_ui32DataSize),1,fp);
		if(pChunk->m_pData)fwrite(pChunk->m_pData,pChunk->m_ui32DataSize,1,fp);

		SerializeOut_Helper(fp,pChunk->m_pChild);

		pChunk = pChunk->m_pSibling;
	}
}

void DataChunk::SerializeOut_Helper(Stream *pStream,stChunk *p)
{
	if(!p || !pStream)return;

	stChunk *pChunk = p;
	while(pChunk)
	{
		pStream->write(&pChunk->m_ui32Type,sizeof(pChunk->m_ui32Type));
		uint chunkSize = pChunk->m_ui32ChunkSize - CHUNK_MIN_SIZE;
		pStream->write(&chunkSize,sizeof(chunkSize));
		//fwrite(&pChunk->m_ui32DataSize,sizeof(pChunk->m_ui32DataSize),1,fp);
		if(pChunk->m_pData)pStream->write(pChunk->m_pData,pChunk->m_ui32DataSize);

		SerializeOut_Helper(pStream,pChunk->m_pChild);

		pChunk = pChunk->m_pSibling;
	}
}

void DataChunk::save(Stream* pStream)
{
	if(!m_pChunk)return;
	if(!pStream)return;

	BuildChunkSize(m_pChunk);
	SerializeOut_Helper(pStream,m_pChunk);
}

void DataChunk::save(const char* szFileName)
{
	if(!m_pChunk)return;
	
	BuildChunkSize(m_pChunk);

	FILE *fp = fopen(szFileName,"wb+");
	if(!fp)return;

	SerializeOut_Helper(fp,m_pChunk);

	fclose(fp);
}

void DataChunk::operateChunk(uint ui32ID,Stream* pData,uint size)
{
	return;
}

//-----------------------------------------------------------------------------------------

DataChunk::stChunk* DataChunk::readChunk(Stream* pData,bool bWowFormat)
{
	uint ui32Type;
	uint ui32ChunkSize,ui32DataSize;
	uchar *pChunkData;

	pData->read(&ui32Type,sizeof(ui32Type));
	pData->read(&ui32DataSize,sizeof(ui32DataSize));

	if(bWowFormat)
	{
		if(ui32Type == 'MCAL' && ui32DataSize == 0xfffff800)
		{
			ui32DataSize = 0;
		}
	}
	pChunkData = new uchar[ui32DataSize];//pData->getBuffer() + pData->getPosition();
	//pData->seek(ui32DataSize,SEEK_CUR);
	pData->read(pChunkData,ui32DataSize);
	ui32ChunkSize = sizeof(ui32Type) + sizeof(ui32DataSize) + ui32DataSize;

	if(bWowFormat)
	{
		if(ui32Type == 'MCNR')
		{
			pData->seek(0x1c0 - 0x1b3,SEEK_CUR);
		}
		if(ui32Type == 'MCLQ')
		{
		}
	}

	return new stChunk(ui32Type,ui32ChunkSize,ui32DataSize,pChunkData,0,0);
}
DataChunk::stChunk* DataChunk::beginChunk(Stream* pData,bool bWowFormat)
{
	if(pData->getLength() < CHUNK_MIN_SIZE)
	{
		return 0;
	}
	m_pCurrentChunk = m_pChunk = readChunk(pData,bWowFormat);

	return m_pCurrentChunk;
}

DataChunk::stChunk* DataChunk::nextChunk(Stream* pData,bool bWowFormat)
{
	if(pData->getLength() - pData->getPosition() < CHUNK_MIN_SIZE)
	{
		return 0;
	}

	m_pCurrentChunk->m_pSibling = readChunk(pData,bWowFormat);

	m_pCurrentChunk = m_pCurrentChunk->m_pSibling;

	return m_pCurrentChunk;
}


uchar* DataChunk::getAbsoluteDataPointer()
{
	return m_data.getBuffer() + m_data.getPosition();
}

DataChunk::stChunk* DataChunk::beginChunk(uchar* pData,uint size,bool bWowFormat)
{
	m_data.attach(pData,size);
	return beginChunk(&m_data,bWowFormat);
}

DataChunk::stChunk* DataChunk::nextChunk(bool bWowFormat)
{
	return nextChunk(&m_data,bWowFormat);
}

DataChunk::stChunk* DataChunk::beginChunk(uint ui32Type,Stream** pDataStream)
{
	stChunk *pChunk = new stChunk(ui32Type);
	if(pDataStream)*pDataStream = &pChunk->m_data;
	if(!m_pChunk)m_pChunk = pChunk;

	stChunk *pParentChunk = 0;
	if(!m_vChunks.empty())
	{
		pParentChunk = m_vChunks.back();
		if(!pParentChunk->m_pChild)pParentChunk->m_pChild = pChunk;
	}

	if(m_pCurrentChunk != pParentChunk)m_pCurrentChunk->m_pSibling = pChunk;

	m_pCurrentChunk = pChunk;
	m_vChunks.push_back(pChunk);

	return pChunk;
}

void DataChunk::endChunk()
{
	m_pCurrentChunk = m_vChunks.back();

	m_pCurrentChunk->m_ui32DataSize = m_pCurrentChunk->m_data.getLength();
	m_pCurrentChunk->m_pData = new uchar[m_pCurrentChunk->m_ui32DataSize];
	memcpy(m_pCurrentChunk->m_pData,(void*)m_pCurrentChunk->m_data.getBuffer(),m_pCurrentChunk->m_ui32DataSize);

	m_vChunks.pop_back();
}

uint DataChunk::getOffset()
{
	return BuildChunkSize(m_pChunk);
}

}