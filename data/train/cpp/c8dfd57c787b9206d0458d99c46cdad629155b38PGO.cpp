// PGO.cpp : Defines the entry point for the DLL application.
//

#include "stdafx.h"
#include <LVPS.h>
#include <LVPS_GraphicModel.hxx>

#include "LVPS_Shape.h"
#include "LVPS_GCam.h"
#include "LVPS_DOTD.h"
#include "LVPS_PRUG.h"
#include "LVPS_AERHT.h"
#include "LVPS_GSV.h"
#include "LVPS_GRETS.h"
#include "LVPS_AKLAB.h"
#include "LVPS_AKLAB3D.h"
#include "LVPS_D3LAB.h"
#include "LVPS_GROT2.h"
#include "LVPS_GROT3.h"
#include "LVPS_GTRANS.h"
#include "LVPS_TRTER.h"
#include "LVPS_KN3EF.h"
#include "LVPS_KN3FF.h"
#include "LVPS_EL3DP.h"
#include "LVPS_LSK3D.h"
#include "LVPS_Point.h"
#include "LVPS_PRLGRM.h"
#include "LVPS_CIL3DC.h"
#include "LVPS_RECTD.h"
#include "LVPS_LSK.h"
#include "LVPS_Lined.h"
#include "LVPS_Linev.h"
#include "LVPS_AMORT.h"
#include "LVPS_ARROW.h"
#include "LVPS_GCYL.h"
#include "LVPS_CMASS.h"
//#include "LVPS_ELPSMD.h"
#include "LVPS_GNIRS.h"
#include "LVPS_HS2VS.h"
#include "LVPS_OPORA.h"
#include "LVPS_OPORAD.h"
#include "LVPS_SILUET.h"
#include "LVPS_KONTUR.h"
#include "LVPS_PRUZS.h"
#include "LVPS_FORTRAN.h"
#include "LVPS_ELP3D.h"


#ifdef Q_WS_WIN
#define MY_EXPORT __declspec(dllexport)
#else
#define MY_EXPORT
#endif

extern "C" MY_EXPORT LVPS_GraphicModel* FORTRAN()
{
	LVPS_GraphicModel* model = new LVPS_FORTRAN();
	return model;
}

extern "C" MY_EXPORT LVPS_GraphicModel* DOTD()
{
	LVPS_GraphicModel* model = new LVPS_DOTD();
	return model;
}

extern "C" MY_EXPORT LVPS_GraphicModel* PRUG()
{
	LVPS_GraphicModel* model = new LVPS_PRUG();
	return model;
}

extern "C" MY_EXPORT LVPS_GraphicModel* AERHT()
{
	LVPS_GraphicModel* model = new LVPS_AERHT();
	return model;
}

extern "C" MY_EXPORT LVPS_GraphicModel* GSV()
{
	LVPS_GraphicModel* model = new LVPS_GSV();
	return model;
}

extern "C" MY_EXPORT LVPS_GraphicModel* GRETS()
{
	LVPS_GraphicModel* model = new LVPS_GRETS();
	return model;
}

extern "C" MY_EXPORT LVPS_GraphicModel* AKLAB()
{
	LVPS_GraphicModel* model = new LVPS_AKLAB();
	return model;
}

extern "C" MY_EXPORT LVPS_GraphicModel* AKLAB3D()
{
	LVPS_GraphicModel* model = new LVPS_AKLAB3D();
	return model;
}

extern "C" MY_EXPORT LVPS_GraphicModel* D3LAB()
{
	LVPS_GraphicModel* model = new LVPS_D3LAB();
	return model;
}

extern "C" MY_EXPORT LVPS_GraphicModel* GROT2()
{
	LVPS_GraphicModel* model = new LVPS_GROT2();
	return model;
}

extern "C" MY_EXPORT LVPS_GraphicModel* GROT3()
{
	LVPS_GraphicModel* model = new LVPS_GROT3();
	return model;
}

extern "C" MY_EXPORT LVPS_GraphicModel* TRTER()
{
	LVPS_GraphicModel* model = new LVPS_TRTER();
	return model;
}

extern "C" MY_EXPORT LVPS_GraphicModel* KN3EFV()
{
	LVPS_GraphicModel* model = new LVPS_KN3EF();
	return model;
}

extern "C" MY_EXPORT LVPS_GraphicModel* KN3FFV()
{
	LVPS_GraphicModel* model = new LVPS_KN3FF();
	return model;
}

extern "C" MY_EXPORT LVPS_GraphicModel* EL3DP()
{
	LVPS_GraphicModel* model = new LVPS_EL3DP();
	return model;
}

extern "C" MY_EXPORT LVPS_GraphicModel* LSK3D()
{
	LVPS_GraphicModel* model = new LVPS_LSK3D();
	return model;
}


extern "C" MY_EXPORT LVPS_GraphicModel* Point()
{
	LVPS_GraphicModel* model = new LVPS_Point();
	return model;
}

extern "C" MY_EXPORT LVPS_GraphicModel* PRLGRM()
{
	LVPS_GraphicModel* model = new LVPS_PRLGRM();
	return model;
}

extern "C" MY_EXPORT LVPS_GraphicModel* CIL3DC()
{
	LVPS_GraphicModel* model = new LVPS_CIL3DC();
	return model;
}

extern "C" MY_EXPORT LVPS_GraphicModel* RECTD()
{
	LVPS_GraphicModel* model = new LVPS_RECTD();
	return model;
}

extern "C" MY_EXPORT LVPS_GraphicModel* LSK()
{
	LVPS_GraphicModel* model = new LVPS_LSK();
	return model;
}

extern "C" MY_EXPORT LVPS_GraphicModel* Lined()
{
	LVPS_GraphicModel* model = new LVPS_Lined();
	return model;
}

extern "C" MY_EXPORT LVPS_GraphicModel* Linev()
{
	LVPS_GraphicModel* model = new LVPS_Linev();
	return model;
}

extern "C" MY_EXPORT LVPS_GraphicModel* AMORT()
{
	LVPS_GraphicModel* model = new LVPS_AMORT();
	return model;
}

extern "C" MY_EXPORT LVPS_GraphicModel* ARROW()
{
	LVPS_GraphicModel* model = new LVPS_ARROW();
	return model;
}

extern "C" MY_EXPORT LVPS_GraphicModel* GCYL()
{
	LVPS_GraphicModel* model = new LVPS_GCYL();
	return model;
}

extern "C" MY_EXPORT LVPS_GraphicModel* GTRANS()
{
	LVPS_GraphicModel* model = new LVPS_GTRANS();
	return model;
}

extern "C" MY_EXPORT LVPS_GraphicModel* CMASS()
{
	LVPS_GraphicModel* model = new LVPS_CMASS();
	return model;
}

extern "C" MY_EXPORT LVPS_GraphicModel* GNIRS()
{
	LVPS_GraphicModel* model = new LVPS_GNIRS();
	return model;
}

extern "C" MY_EXPORT LVPS_GraphicModel* HS2VS()
{
	LVPS_GraphicModel* model = new LVPS_HS2VS();
	return model;
}

extern "C" MY_EXPORT LVPS_GraphicModel* OPORA()
{
	LVPS_GraphicModel* model = new LVPS_OPORA();
	return model;
}

extern "C" MY_EXPORT LVPS_GraphicModel* OPORAD()
{
	LVPS_GraphicModel* model = new LVPS_OPORAD();
	return model;
}

extern "C" MY_EXPORT LVPS_GraphicModel* SILUET()
{
	LVPS_GraphicModel* model = new LVPS_SILUET();
	return model;
}

extern "C" MY_EXPORT LVPS_GraphicModel* KONTUR()
{
	LVPS_GraphicModel* model = new LVPS_KONTUR();
	return model;
}

extern "C" MY_EXPORT LVPS_GraphicModel* PRUZS()
{
	LVPS_GraphicModel* model = new LVPS_PRUZS();
	return model;
}

extern "C" MY_EXPORT LVPS_GraphicModel* ELP3D()
{
	LVPS_GraphicModel* model = new LVPS_ELP3D();
	return model;
}

extern "C" MY_EXPORT LVPS_GraphicModel* SHAPE()
{
	LVPS_GraphicModel* model = new LVPS_Shape();
	return model;
}


extern "C" MY_EXPORT LVPS_GraphicModel* GCAM()
{
//	QMessageBox::information(0,"","PGO.cpp:createCam");

	LVPS_GraphicModel* model = new LVPS_GCam();
	return model;
}

//extern "C" MY_EXPORT LVPS_GraphicModel* ELPSMD()   // !!!! Not DONE !!!!
//{
//	LVPS_GraphicModel* model = new LVPS_ELPSMD();
//	return model;
//}



BOOL APIENTRY DllMain( HANDLE hModule, 
                       DWORD  ul_reason_for_call, 
                       LPVOID lpReserved
					 )
{
//	QMessageBox::information(0,"2","PGO.cpp:createCam");
    return TRUE;
}

