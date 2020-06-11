#include "CUtil/inc/Chunk.h"
#include "CUtil/inc/CUtil.h"

namespace CUtil
{ 
	void* ChunkData::operator new (size_t size , UINT32 extra)
	{ 
		return malloc(size + extra);
	}
	void  ChunkData::operator delete (void *p , UINT32 extra)
	{ 
		free(p); 
	}
// 
// 	ChunkData::ChunkData(void * pBuf , UINT32 unChunkSize)
// 		: m_unSize(0)
// 		, m_unDataLen(0) 
// 		, m_refCount(0)
// 	{
// 		if (unChunkSize)
// 		{
// 			Reverse(unChunkSize); 
// 			memcpy(GetData() , pBuf , unChunkSize);
// 			m_unDataLen = unChunkSize;
// 		}
// 	}
// 
// 	ChunkData::ChunkData(UINT32 unChunkSize)
// 		: m_unSize(0)
// 		, m_unDataLen(0)
// 		, m_refCount(0)
// /*		, m_pBuf(NULL)*/
// /*		, m_bMustRelease(TRUE)*/
// 	{
// 		if (unChunkSize)
// 		{
// 			Reverse(unChunkSize);  
// 			m_unDataLen = unChunkSize;
// 		}  
// 	}
//	 
// 	ChunkData::ChunkData(const ChunkData & objChunk)
// 		: m_unSize(0)
// 		, m_unDataLen(0)
/*		, m_pBuf(NULL)*/
/*		, m_bMustRelease(TRUE)*/
// 	{
// 		if (&objChunk != this)
// 		{
// 			DecRef();
// 			Begin() = (ChunkData*)(&objChunk);
// 		}
// 		Reverse(objChunk.GetDataLen());
// 		memcpy(m_pBuf , objChunk.GetData() , objChunk.GetDataLen());
// 		m_unDataLen = objChunk.GetDataLen();
//	}
//
// 	ChunkData	& ChunkData::operator=(const ChunkData & objChunk)
// 	{
// 		Reverse(objChunk.GetDataLen());
// 		memcpy(m_pBuf , objChunk.GetData() , objChunk.GetDataLen());
// 		m_unDataLen = objChunk.GetDataLen();
// 
// 		return * this;
// 	}
 
	bool ChunkData::operator ==(const ChunkData & objChunk) const
	{
		if (objChunk.GetDataLen() == m_unDataLen && !memcmp(this->GetData() , objChunk.GetData() , m_unDataLen))
		{
			return true;
		}

		return false;
	}

	bool ChunkData::operator !=(const ChunkData & objChunk) const
	{
		if (objChunk.GetDataLen() != m_unDataLen || memcmp(this->GetData() , objChunk.GetData() , m_unDataLen))
		{
			return true;
		}

		return false;
	}

// 	ChunkData::~ChunkData()
// 	{
// /*		DecRef();*/
// 	}

	ChunkData	* ChunkData::Reverse(UINT32 unSize)
	{
		if (m_refCount >= 0 || unSize > m_unSize)
		{
			unSize = FitSize(unSize);

			if (unSize > m_unSize)
			{
				ChunkData * pBuf = Create(unSize);
				memcpy(pBuf->GetData() , this->GetData() , pBuf->m_unDataLen = m_unDataLen);

				DecRef();
				return pBuf;
			}
		}
		return this;
	}

	UINT32 ChunkData::FitSize(UINT32 unSize)
	{
		UINT32 unTmp = 8;
		while (unSize > unTmp)
		{
			unTmp <<= 1;
		}

		return unTmp;
	}

	ChunkData	* ChunkData::Create(UINT32 unSize)
	{ 
		ChunkData * pData = new (unSize) ChunkData;
		pData->m_unSize = unSize;
		pData->m_unDataLen = 0;
		pData->AddRef();

		return pData;
	}

	void * ChunkData::Insert(void * pPos , void * pBegin , UINT32 unLen)
	{
		PtrDiff off = (char *)pPos - (char *)GetData();

		ChunkData * pData = Reverse(m_unDataLen + unLen);
		MsgAssert_Re0(pData , "no space.");

		pPos = (char *)(pData->GetData()) + off;

		UINT32 unAdjust = pData->m_unDataLen - (UINT32)off;  //5 这里是万一向中间内存块插入
		if (unAdjust)
		{
			FastMemmove((char *)pPos + unLen , pPos , unAdjust);
		}

		FastMemmove((char *)pPos , pBegin , unLen);
		pData->m_unDataLen += unLen;

		return pData->GetData();
	}

	void * ChunkData::Pushback(void * pBegin , UINT32 unLen)
	{
		ChunkData * pData = Reverse(m_unDataLen + unLen);

		FastMemmove((char *)(pData->GetData())+ pData->m_unDataLen , pBegin , unLen);
		pData->m_unDataLen += unLen;

		return pData->GetData();
	}

	void    * ChunkData::End(void)
	{
		return (char *)GetData() + m_unDataLen;
	}

	void    * ChunkData::Begin(void)
	{
		return (void*)this;
	}

	ChunkData   & ChunkData::Erase(void * pBegin , void * pEnd)
	{
		if (pBegin != pEnd)
		{
			FastMemmove(pBegin , pEnd , ((char *)GetData() + m_unDataLen ) - (char *)pBegin);
			m_unDataLen = m_unDataLen - (UINT32)((char*)pEnd - (char*)pBegin);
			MsgAssert_Re(m_unDataLen >= 0 , *this ,"chunk erase so long.");
		}

		return *this;
	}

	void ChunkData::Clear(void)
	{ 
		memset((char*)(this+1) , 0 , m_unDataLen);
		m_unDataLen = 0;
	}

	void ChunkData::AddRef(void)
	{
		if (m_refCount >= 0)
		{
			++m_refCount;
		}
	}

	void ChunkData::DecRef(void)
	{
		if (m_refCount > 0)
		{
			--m_refCount;
			if (m_unSize != 0 && m_refCount == 0)
			{
				delete((void*)this);
			}
		}
	}

	ChunkData	& ChunkData::Null()
	{
		static ChunkData s_null(-1);
		return s_null;
	}

	Chunk::Chunk(const Chunk & objChunk)
		: m_pData(objChunk.m_pData)
	{
		GetChunkData()->AddRef();
	}

	Chunk	& Chunk::operator=(const Chunk & objChunk)
	{
		if (&objChunk != this)
		{
			this->GetChunkData()->DecRef();
			m_pData = objChunk.m_pData;
			GetChunkData()->AddRef();
		}

		return * this;
	}

	bool Chunk::operator!=(const Chunk & objChunk) const
	{ 
		return *GetChunkData() != (*objChunk.GetChunkData());
// 		if (objChunk.GetDataLen() != GetDataLen() || memcmp(m_pData , objChunk.Begin() , GetDataLen()))
// 		{
// 			return true;
// 		}
// 		return false;
	}

	bool Chunk::operator==(const Chunk & objChunk) const
	{
		return *GetChunkData() == (*objChunk.GetChunkData());
// 		if (objChunk.GetDataLen() == GetDataLen() && !memcmp(m_pData , objChunk.Begin() , GetDataLen()))
// 		{
// 			return true;
// 		}
// 		return false;		
	}

	Chunk & Chunk::Insert(void * pPos , void * pBegin , UINT32 unLen)
	{
		m_pData = GetChunkData()->Insert(pPos , pBegin , unLen);

		return * this;
	}

	Chunk & Chunk::Pushback(void * pBegin , UINT32 unLen)
	{
		m_pData = GetChunkData()->Pushback(pBegin , unLen);

		return * this;
	}

	Chunk & Chunk::Erase(void * pBegin , void * pEnd)
	{ 
		GetChunkData()->Erase(pBegin , pEnd);

		return * this;
	}

	Chunk & Chunk::Reverse(UINT32 unSize)
	{
		m_pData = GetChunkData()->Reverse(unSize)->GetData();
		return * this;
	}

	void * Chunk::Begin(void)
	{
		return m_pData;
	}

	void * Chunk::Begin(void) const
	{
		return m_pData;
	}

	void * Chunk::End(void)
	{
		return GetChunkData()->End();
	}

	void * Chunk::End(void) const
	{
		return GetChunkData()->End();
	}

	void Chunk::Clear(void)
	{
		GetChunkData()->Clear();
	}
	std::ostream & operator<<(std::ostream&os,const Chunk & objChunk)
	{
		return os << "chunk:size=" << objChunk.GetSize() << ":datalen=" << objChunk.GetDataLen() << ":data=" << objChunk.Begin();
	}

}