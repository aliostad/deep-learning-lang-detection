//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop

#include "MCK.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
//---------------------------------------------------------------------------
CK::CK(void):CStdElement()
{
   ID_OBJECT = ID_K;
   K = 1.0;
   ElName = "Óñèëèòåëüíîå çâåíî";
   FKProp = NULL;
}
//---------------------------------------------------------------------------
void __fastcall CK::SetData(void)
{
	FKProp = new TFKProp(Application);
   FKProp->EK->Text = FloatToStr(K);
   FKProp->ShowModal();
   if(FKProp->ResultOk)
   {
   	K = FKProp->K;
   }
   FKProp->Free();
}
//---------------------------------------------------------------------------
void CK::FUNKCIJA(int index, int end, long double DT)
{
   Out[index] = K*real(In[index]);
}
//---------------------------------------------------------------------------
void __fastcall CK::GetDump(void *&Dump, DWORD &DumpSize)
{
	CStdElement::GetDump(Dump, DumpSize);
   AddValue(Dump, DumpSize, &K, sizeof(long double));
}
//---------------------------------------------------------------------------
void __fastcall CK::SetDump(void *&Dump, DWORD &DumpSize)
{
	CStdElement::SetDump(Dump, DumpSize);
   GetValue(Dump, DumpSize, &K, sizeof(long double));
}
//---------------------------------------------------------------------------
