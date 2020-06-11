#ifndef __msg_chunk_h__
#define __msg_chunk_h__ 
#include "MsgCommon.h" 

namespace Msg
{ 
	class  Chunk
	{
	public: 
		Chunk() : m_unChunkSize(0) , m_pBuf(NULL){}
		Chunk(void * pBuf , UINT32 unChunkSize) : m_unChunkSize(unChunkSize) , m_pBuf((char *)pBuf){}
		~Chunk(){}

	public:
		char    *  GetBuf(){ return m_pBuf; }
		void       SetBuf(void * pBuf){ m_pBuf = (char *)pBuf; }
		UINT32     GetSize(){ return m_unChunkSize; }
		void       SetSize(UINT32 unChunkSize){ m_unChunkSize = unChunkSize; }

	private:
		char    *  m_pBuf;
		UINT32     m_unChunkSize;
	};

}
#endif