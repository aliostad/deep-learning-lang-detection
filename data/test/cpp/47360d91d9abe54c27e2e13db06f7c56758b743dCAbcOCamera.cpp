//*****************************************************************************
/*!
	Copyright 2013 Autodesk, Inc.  All rights reserved.
	Use of this software is subject to the terms of the Autodesk license agreement
	provided at the time of installation or download, or which otherwise accompanies
	this software in either electronic or hard copy form.
*/
//*

#include "CAbcOCamera.h"
#include <Alembic/AbcCoreAbstract/TimeSampling.h>


CAbcOCameraSample::CAbcOCameraSample()
{
}

void CAbcOCameraSample::SetFocalLength( double in_dFocalLength )
{
	m_CameraSample.setFocalLength( in_dFocalLength );
}

void CAbcOCameraSample::SetAperture( double in_dHorizAperture, double in_dVertAperture )
{
	m_CameraSample.setHorizontalAperture( in_dHorizAperture );
	m_CameraSample.setVerticalAperture( in_dVertAperture );
}

void CAbcOCameraSample::SetFilmOffset( double in_dHorizOffset, double in_dVertOffset )
{
	m_CameraSample.setHorizontalFilmOffset( in_dHorizOffset );
	m_CameraSample.setVerticalFilmOffset( in_dVertOffset );
}

void CAbcOCameraSample::SetLensSqueezeRatio( double in_dRatio )
{
	m_CameraSample.setLensSqueezeRatio( in_dRatio );
}

void CAbcOCameraSample::SetOverscan( double in_dLeft, double in_dRight, double in_dTop, double in_dBottom )
{
	m_CameraSample.setOverScanLeft( in_dLeft );
	m_CameraSample.setOverScanRight( in_dRight );
	m_CameraSample.setOverScanTop( in_dTop );
	m_CameraSample.setOverScanBottom( in_dBottom );
}

void CAbcOCameraSample::SetFStop( double in_dFStop )
{
	m_CameraSample.setFStop( in_dFStop );
}

void CAbcOCameraSample::SetFocusDistance( double in_dFocusDistance )
{
	m_CameraSample.setFocusDistance( in_dFocusDistance );
}

void CAbcOCameraSample::SetShutterOpen( double in_dTime )
{
	m_CameraSample.setShutterOpen( in_dTime );
}

void CAbcOCameraSample::SetShutterClose( double in_dTime )
{
	m_CameraSample.setShutterClose( in_dTime );
}

void CAbcOCameraSample::SetClippingPlanes( double in_dNear, double in_dFar )
{
	m_CameraSample.setNearClippingPlane( in_dNear );
	m_CameraSample.setFarClippingPlane( in_dFar );
}

void CAbcOCameraSample::SetChildBounds( const Alembic::Abc::Box3d& in_BBox )
{
	m_CameraSample.setChildBounds( in_BBox );
}

const Alembic::AbcGeom::CameraSample& CAbcOCameraSample::GetSample() const
{
	return m_CameraSample;
}

void CAbcOCamera::AddCameraSample( const IAbcOCameraSample* in_pSample )
{
	if ( in_pSample == NULL )
		return;

	CAbcOCameraSample* l_pSample = (CAbcOCameraSample*)in_pSample;
	GetSchema().set( l_pSample->GetSample() );
}

EAbcResult CAbcOCamera::CreateCameraSample( IAbcOCameraSample** out_ppSample )
{
	if ( out_ppSample == NULL )
		return EResult_InvalidPtr;

	CAbcOCameraSample* l_pNewSample = new CAbcOCameraSample();

	if ( l_pNewSample )
	{
		l_pNewSample->AddRef();
		*out_ppSample = l_pNewSample;
		return EResult_Success;
	}
	else
		return EResult_OutOfMemory;
}
