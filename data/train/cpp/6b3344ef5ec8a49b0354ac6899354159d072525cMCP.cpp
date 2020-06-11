//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop

#include "MCP.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
//---------------------------------------------------------------------------
CP::CP(void):CStdElement()
{
   ID_OBJECT = ID_P;
   C1 = 1.0;
   ElName = "Ï-ðåãóëÿòîð";
   FPProp = NULL;
}
//---------------------------------------------------------------------------
void __fastcall CP::SetData(void)
{
	FPProp = new TFPProp(Application);
   FPProp->EC1->Text = FloatToStr(C1);
   FPProp->ShowModal();
   if(FPProp->ResultOk)
   {
   	C1 = FPProp->C1;
   }
   FPProp->Free();
}
//---------------------------------------------------------------------------
void CP::FUNKCIJA(int index, int end, long double DT)
{
	Out[index] = C1*In[index];
}
//---------------------------------------------------------------------------
void __fastcall CP::GetDump(void *&Dump, DWORD &DumpSize)
{
	CStdElement::GetDump(Dump, DumpSize);
   AddValue(Dump, DumpSize, &C1, sizeof(long double));
}
//---------------------------------------------------------------------------
void __fastcall CP::SetDump(void *&Dump, DWORD &DumpSize)
{
	CStdElement::SetDump(Dump, DumpSize);
   GetValue(Dump, DumpSize, &C1, sizeof(long double));
}
//---------------------------------------------------------------------------
