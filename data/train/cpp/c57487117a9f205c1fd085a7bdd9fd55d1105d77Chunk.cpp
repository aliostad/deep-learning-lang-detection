/**
@file Chunk.cpp
@author nieznanysprawiciel
@copyright File is part of Sleeping Wombat Libraries.
*/

#include "swCommonLib/HierarchicalChunkedFormat/stdafx.h"

#include "swCommonLib/HierarchicalChunkedFormat/Chunk.h"
#include "swCommonLib/HierarchicalChunkedFormat/Internal/ChunkRepr.h"

namespace sw
{

// ================================ //
//
Chunk::Chunk		( ChunkReprPtr chunkRepr )
	:	m_chunkPtr( chunkRepr )
{}

// ================================ //
//
Chunk			Chunk::CreateChunk		()
{
	if( IsValid() )
		return m_chunkPtr->CreateChunk();
	return Chunk( nullptr );
}

// ================================ //
//
Chunk			Chunk::NextChunk()
{
	if( IsValid() )
		return m_chunkPtr->NextChunk();
	return Chunk( nullptr );
}

// ================================ //
//
Chunk			Chunk::FirstChild()
{
	if( IsValid() )
		return m_chunkPtr->FirstChild();
	return Chunk( nullptr );
}

// ================================ //
//
bool			Chunk::HasChildren()
{
	if( IsValid() )
		return m_chunkPtr->HasChildren();
	return false;
}

// ================================ //
//
Chunk			Chunk::ParentChunk()
{
	if( IsValid() )
		return m_chunkPtr->ParentChunk();
	return Chunk( nullptr );
}

// ================================ //
//
Attribute		Chunk::AddAttribute		( AttributeType type, const DataPtr data, Size dataSize )
{
	if( IsValid() )
		return m_chunkPtr->AddAttribute( type, data, dataSize );
	return Attribute( nullptr );
}

// ================================ //
//
bool			Chunk::Fill				( const DataPtr data, Size dataSize )
{
	if( IsValid() )
		return m_chunkPtr->Fill( data, dataSize );
	return false;
}

// ================================ //
//
DataUPack		Chunk::StealData()
{
	if( IsValid() )
		return m_chunkPtr->StealData();
	return DataUPack();
}

// ================================ //
//
DataPack		Chunk::AccessData()
{
	if( IsValid() )
		return m_chunkPtr->AccessData();
	return DataPack();
}

// ================================ //
//
bool			Chunk::IsValid() const
{
	if( m_chunkPtr )
		return true;
	return false;
}

// ================================ //
//
bool			Chunk::operator==	( Chunk other ) const
{
	if( m_chunkPtr == other.m_chunkPtr )
		return true;
	return false;
}

}	// sw
