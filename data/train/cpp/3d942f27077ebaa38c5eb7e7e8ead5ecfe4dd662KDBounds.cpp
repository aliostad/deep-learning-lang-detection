#include "KDBounds.h"



// write to the stream
std::ostream& operator<<( std::ostream &stream,  const KDBounds& v )
{
	stream<<v.m_pos.x<<'\n';
	stream<<v.m_pos.y<<'\n';
	stream<<v.m_pos.z<<'\n';
	stream<<v.m_extents.x<<'\n';
	stream<<v.m_extents.y<<'\n';
	stream<<v.m_extents.z<<'\n';
	//stream<<'\n';
	//stream.write( (char*)&v.m_extents, sizeof(v.m_extents) );
	//stream<<'\n';
	return stream;
}

std::ifstream& operator>>( std::ifstream &stream,  KDBounds& v )
{
	//stream.read( (char*)&v.m_pos, sizeof(v.m_pos) );
	//stream.read( (char*)&v.m_extents, sizeof(v.m_extents) );
	stream>>v.m_pos.x;
	stream>>v.m_pos.y;
	stream>>v.m_pos.z;
	stream>>v.m_extents.x;
	stream>>v.m_extents.y;
	stream>>v.m_extents.z;
	return stream;
}