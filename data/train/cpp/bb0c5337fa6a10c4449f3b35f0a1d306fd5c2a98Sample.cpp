#include "Common.h"
#include "HLE/modules/HLEModuleFunction.h"
#include "HLE/modules/HLEThread.h"
#include "HLE/modules/HLEModuleManager.h"
#include "HLE/modules/HLEModule.h"
#include "Sample.h"



Sample::pspSampleFooFunc *pspSampleFooFunction=new Sample::pspSampleFooFunc("Sample", "pspSampleFoo");


string Sample::getName()
{
   return "Sample";
}
void Sample::pspSampleFoo()
{

}
void Sample::installModule(int version)
{
	HLEModuleManager::addFunction(pspSampleFooFunction, 0x15151515);
}
void Sample::uninstallModule(int version)
{
	HLEModuleManager::removeFunction(pspSampleFooFunction);
}
 