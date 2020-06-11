// DesktopEarlabDLL.cpp : Defines the entry point for the DLL application.
//
#define DEFINE_GLOBAL_LOGGER
#include "Model.h"
#include "DesktopEarlabDLL.h"
#include "EarlabException.h"
#include <stdio.h>

BOOL APIENTRY DllMain( HANDLE hModule, 
                       DWORD  ul_reason_for_call, 
                       LPVOID lpReserved
					 )
{
	switch (ul_reason_for_call)
	{
	case DLL_PROCESS_ATTACH:
	case DLL_THREAD_ATTACH:
	case DLL_THREAD_DETACH:
	case DLL_PROCESS_DETACH:
		break;
	}
    return TRUE;
}

DESKTOPEARLABDLL_API void *CreateModel(void)
{
	return new Model();
}

DESKTOPEARLABDLL_API int SetModuleDirectory(void *ModelPtr, char *ModuleDirectoryPath)
{
	Model *newModel = (Model *)ModelPtr;
	return newModel->SetModuleDirectory(ModuleDirectoryPath);
}

DESKTOPEARLABDLL_API void SetLogCallback(void *ModelPtr, LogCallback theCallback)
{
	Model *newModel = (Model *)ModelPtr;
	gLogger.SetLogCallback(theCallback);
	newModel->SetLogger(&gLogger);
}

DESKTOPEARLABDLL_API int LoadModelConfigFile(void *ModelPtr, char *ModelConfigFileName, float FrameSize_uS)
{
	Model *newModel = (Model *)ModelPtr;
	try
	{
		return newModel->Load(ModelConfigFileName, FrameSize_uS);
	}
	catch (EarlabException e)
	{
		gLogger.Log("Model threw exception during LoadModelConfigFile: %s", e.GetExceptionString());
	}
	return 0;
}

DESKTOPEARLABDLL_API int LoadModuleParameters(void *ModelPtr, char *ModuleParameterFileName)
{
	Model *newModel = (Model *)ModelPtr;
	try
	{
		return newModel->LoadModuleParameters(ModuleParameterFileName);
	}
	catch (EarlabException e)
	{
		gLogger.Log("Model threw exception during LoadModuleParameters: %s", e.GetExceptionString());
	}
	return 0;
}

DESKTOPEARLABDLL_API int StartModules(void *ModelPtr)
{
	Model *newModel = (Model *)ModelPtr;
	try
	{
		return newModel->StartModules();
	}
	catch (EarlabException e)
	{
		gLogger.Log("Model threw exception during StartModules: %s", e.GetExceptionString());
	}
	return 0;
}

DESKTOPEARLABDLL_API int RunModel(void *ModelPtr, int NumFrames)
{
	Model *newModel = (Model *)ModelPtr;
	try
	{
		return newModel->Run(NumFrames);
	}
	catch (EarlabException e)
	{
		gLogger.Log("Model threw exception during RunModel: %s", e.GetExceptionString());
	}
	return 0;
}

DESKTOPEARLABDLL_API int AdvanceModules(void *ModelPtr)
{
	Model *newModel = (Model *)ModelPtr;
	try
	{
		return newModel->AdvanceModules();
	}
	catch (EarlabException e)
	{
		gLogger.Log("Model threw exception during AdvanceModules: %s", e.GetExceptionString());
	}
	return 0;
}

DESKTOPEARLABDLL_API int StopModules(void *ModelPtr)
{
	Model *newModel = (Model *)ModelPtr;
	gLogger.Log("StopModules(DLL) About to call StopModules()");
	try
	{
		return newModel->StopModules();
	}
	catch (EarlabException e)
	{
		gLogger.Log("Model threw exception during StopModules: %s", e.GetExceptionString());
	}
	return 0;
}

DESKTOPEARLABDLL_API int UnloadModel(void *ModelPtr)
{
	Model *newModel = (Model *)ModelPtr;
	int status;

	try
	{
		status = newModel->Unload();
	}
	catch (EarlabException e)
	{
		gLogger.Log("Model threw exception during UnloadModel: %s", e.GetExceptionString());
		status = 0;
	}
	delete newModel;
	return status;
}
