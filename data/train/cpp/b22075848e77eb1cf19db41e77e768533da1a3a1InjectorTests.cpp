// InjectorTests.cpp : main project file.

#include "stdafx.h"
#include "injection\Injector.h"
#include "InjectorTests.h"

using namespace System;

const char* InjectionID::MODEL_A = "InjectionID_MODEL_A";
const char* InjectionID::MODEL_B = "InjectionID_MODEL_B";

int main(array<System::String ^> ^args)
{
    Console::WriteLine(L"Starting InjectorTests");

    ModelAPtr modelA = ModelAPtr(new ModelA());
    ModelBPtr modelB = ModelBPtr(new ModelB());

    Injector injector;

    injector.Map(modelA, InjectionID::MODEL_A);
    injector.Map(modelB, InjectionID::MODEL_B);

    Console::WriteLine(L"Number of injection " + injector.GetNumInjections());

    if (injector.GetInstanceById<ModelAPtr>(InjectionID::MODEL_A))
    {
        Console::WriteLine(L"Model A found in injector");
    }

    injector.UnMap(modelA);

    if (!injector.HasInjection(InjectionID::MODEL_A))
    {
        Console::WriteLine(L"Model A not found in injector");
    }

    Console::WriteLine(L"Number of injection " + injector.GetNumInjections());
    injector.UnMap(InjectionID::MODEL_B);

    Console::WriteLine(L"Number of injection " + injector.GetNumInjections());

    if (!injector.HasInjection(modelB))
    {
        Console::WriteLine(L"Model B not found in injector");
    }

    system("pause");
    return 0;
}