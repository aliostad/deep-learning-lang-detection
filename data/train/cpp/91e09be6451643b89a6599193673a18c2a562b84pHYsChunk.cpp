// pHYsChunk.cpp: implementation of the CpHYsChunk class.
//
//////////////////////////////////////////////////////////////////////

#include "stdafx.h"
#include "pHYsChunk.h"

//////////////////////////////////////////////////////////////////////
// Construction/Destruction
//////////////////////////////////////////////////////////////////////

const unsigned char CpHYsChunk::m_szData[9] = {
	'\x000','\x000','\x00e','\x0c3','\x000','\x000','\x00e','\x0c3','\x001' };

CpHYsChunk::CpHYsChunk()
{
	this->SetChunkType( 0x70485973l);
	this->SetChunkData( (unsigned char *)m_szData, 9 );
}

CpHYsChunk::~CpHYsChunk()
{

}
