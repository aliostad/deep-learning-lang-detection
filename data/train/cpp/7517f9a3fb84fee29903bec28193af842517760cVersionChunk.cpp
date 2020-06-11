#include "StdAfx.h"
#include "VersionChunk.h"
#include "BinarySerializer.h"

namespace IO
{

//------------------------------------------------------------------------------
VersionChunk::VersionChunk()
		: DataChunk('FVER')
		, version(0)
{
	this->size = sizeof(uint);
}

//------------------------------------------------------------------------------
VersionChunk::~VersionChunk()
{
	// empty
}

//------------------------------------------------------------------------------
void VersionChunk::Write()
{
	DataChunk::Write();
	this->serializer->WriteUInt(this->version);
}

//------------------------------------------------------------------------------
void VersionChunk::Read()
{
	DataChunk::Read();
	this->version = this->serializer->ReadUInt();
}

//------------------------------------------------------------------------------
void VersionChunk::SetVersion( uint v )
{
	this->version = v;
}

//------------------------------------------------------------------------------
uint VersionChunk::GetVersion() const
{
	return this->version;
}

}// namespace IO
