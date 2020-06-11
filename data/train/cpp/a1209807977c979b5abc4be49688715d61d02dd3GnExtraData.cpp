#include "GnMainPCH.h"
#include "GnExtraData.h"

GnImplementRTTI(GnExtraData, GnObject);
void GnExtraData::LoadStream(GnObjectStream* pStream)
{
	GnObject::LoadStream( pStream );
	pStream->LoadStream( mID );
	pStream->LoadStream( mType );
}

void GnExtraData::LinkObject(GnObjectStream* pStream)
{
	GnObject::LinkObject( pStream );
}

void GnExtraData::SaveStream(GnObjectStream* pStream)
{
	GnObject::SaveStream( pStream );
	pStream->SaveStream( mID );
	pStream->SaveStream( mType );
}

void GnExtraData::RegisterSaveObject(GnObjectStream* pStream)
{
	GnObject::RegisterSaveObject( pStream );
}

GnImplementRTTI(GnIntExtraData, GnExtraData);
GnImplementCreateObject(GnIntExtraData);
void GnIntExtraData::LoadStream(GnObjectStream* pStream)
{
	GnExtraData::LoadStream( pStream );
	pStream->LoadStream( mVal );
}

void GnIntExtraData::LinkObject(GnObjectStream* pStream)
{
	GnExtraData::LinkObject( pStream );
}

void GnIntExtraData::SaveStream(GnObjectStream* pStream)
{
	GnExtraData::SaveStream( pStream );
	pStream->SaveStream( mVal );
}

void GnIntExtraData::RegisterSaveObject(GnObjectStream* pStream)
{
	GnExtraData::RegisterSaveObject( pStream );
}

GnImplementRTTI(GnVector2ExtraData, GnExtraData);
GnImplementCreateObject(GnVector2ExtraData);
void GnVector2ExtraData::LoadStream(GnObjectStream* pStream)
{
	GnExtraData::LoadStream( pStream );
	pStream->LoadStream( mVector[0] );
	pStream->LoadStream( mVector[1] );
}

void GnVector2ExtraData::LinkObject(GnObjectStream* pStream)
{
	GnExtraData::LinkObject( pStream );
}

void GnVector2ExtraData::SaveStream(GnObjectStream* pStream)
{
	GnExtraData::SaveStream( pStream );
	pStream->SaveStream( mVector[0] );
	pStream->SaveStream( mVector[1] );
}

void GnVector2ExtraData::RegisterSaveObject(GnObjectStream* pStream)
{
	GnExtraData::RegisterSaveObject( pStream );
}
