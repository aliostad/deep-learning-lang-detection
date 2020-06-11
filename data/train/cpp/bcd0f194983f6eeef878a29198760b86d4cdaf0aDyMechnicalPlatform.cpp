// DyMechnicalPlatform.cpp : 定义 DLL 应用程序的导出函数。
//

#include "stdafx.h"
#include "DyMechnicalPlatform.h"

DyMechicalAPI* gv_API=NULL;

DYMECHNICALPLATFORM_API bool API_SysInit( void )
{
	if (gv_API==NULL)
	{
		gv_API=new DyMechicalAPI;
		return gv_API->SysInit();
	}
	else
	{
		return false;
	}
}

DYMECHNICALPLATFORM_API void API_SysQuit( void )
{
	gv_API->SysQuit();
	gv_API=NULL;
	delete gv_API;
}

DYMECHNICALPLATFORM_API bool API_FeedMotor_Start( void )
{
	if (gv_API==NULL)
		return false;
	return gv_API->FeedMotor_Start();
}

DYMECHNICALPLATFORM_API bool API_FeedMotor_Stop( void )
{
	if (gv_API==NULL)
		return false;
	return gv_API->FeedMotor_Stop();
}

DYMECHNICALPLATFORM_API bool API_MotorStart( int motorNum,int direction,int stepNum )
{
	if (gv_API==NULL)
		return false;
	return gv_API->MotorStart(motorNum,direction,stepNum);
}

DYMECHNICALPLATFORM_API bool API_MotorStop( int motorNum )
{
	if (gv_API==NULL)
		return false;
	return gv_API->MotorStop(motorNum);
}

DYMECHNICALPLATFORM_API bool API_MotorReset( int motorNum )
{
	if (gv_API==NULL)
		return false;
	return gv_API->MotorReset(motorNum);
}

DYMECHNICALPLATFORM_API bool API_SetMotorSpeed( int motorNum,int speed )
{
	if (gv_API==NULL)
		return false;
	return gv_API->SetMotorSpeed(motorNum,speed);
}

DYMECHNICALPLATFORM_API bool API_solenAction( int solenNum,int statue )
{
	if (gv_API==NULL)
		return false;
	return gv_API->solenAction(solenNum,statue);
}

DYMECHNICALPLATFORM_API bool API_solenAdvace( int platformNum,int statue )
{
	if (gv_API==NULL)
		return false;
	return gv_API->solenAdvace(platformNum,statue);
}

DYMECHNICALPLATFORM_API void API_getSolenStatue( int* SolenStatue )
{
	if (gv_API==NULL)
		return;
	gv_API->getSolenStatue(SolenStatue);
}

DYMECHNICALPLATFORM_API bool API_getMotorStatue( int* motorStatue )
{
	if (gv_API==NULL)
		return false;
	return gv_API->getMotorStatue(motorStatue);
}

DYMECHNICALPLATFORM_API bool API_getPlatformStatue( int PlatformNum,int* platformStatue )
{
	if (gv_API==NULL)
		return false;
	return gv_API->getPlatformStatue(PlatformNum,platformStatue);
}

DYMECHNICALPLATFORM_API bool API_getSensorStatue( int* SensorStatue )
{
	if (gv_API==NULL)
		return false;
	return gv_API->getSensorStatue(SensorStatue);
}

DYMECHNICALPLATFORM_API bool API_getADSensor( double& value )
{
	if (gv_API==NULL)
		return false;
	return gv_API->GetADSensor(value);
}

DYMECHNICALPLATFORM_API bool API_RcvInit( void )
{
	if (gv_API==NULL)
		return false;
	return gv_API->rcvInit();
}
