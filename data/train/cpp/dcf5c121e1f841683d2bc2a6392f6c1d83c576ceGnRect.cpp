#include "GnMainPCH.h"
#include "GnRect.h"

void GnFRect::LoadStream(GnStream* pStream)
{
	pStream->LoadStreams( (char*)&left, sizeof(float) * 4 );
	//pStream->LoadStream( left );
	//pStream->LoadStream( top );
	//pStream->LoadStream( right );
	//pStream->LoadStream( bottom );
}

void GnFRect::SaveStream(GnStream* pStream)
{
	pStream->SaveStreams( (char*)&left, sizeof(float) * 4 );
	//pStream->SaveStream( left );
	//pStream->SaveStream( top );
	//pStream->SaveStream( right );
	//pStream->SaveStream( bottom );
}



void GnIRect::LoadStream(GnStream* pStream)
{
	pStream->LoadStreams( (char*)&left, sizeof(gint32) * 4 );
	//pStream->LoadStream( left );
	//pStream->LoadStream( top );
	//pStream->LoadStream( right );
	//pStream->LoadStream( bottom );
}

void GnIRect::SaveStream(GnStream* pStream)
{
	pStream->SaveStreams( (char*)&left, sizeof(gint32) * 4 );
	//pStream->SaveStream( left );
	//pStream->SaveStream( top );
	//pStream->SaveStream( right );
	//pStream->SaveStream( bottom );
}