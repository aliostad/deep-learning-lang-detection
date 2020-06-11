//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop

#include "MCI.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
//---------------------------------------------------------------------------
CI::CI(void):CStdElement()
{
   C0 = 1.0;
   ElName = "È-ðåãóëÿòîð";
   FIProp = NULL;
   ID_OBJECT = ID_I;
}
//---------------------------------------------------------------------------
void __fastcall CI::SetData(void)
{
	FIProp = new TFIProp(Application);
   FIProp->EC0->Text = FloatToStr(C0);
   FIProp->ShowModal();
   if(FIProp->ResultOk)
   {
   	C0 = FIProp->C0;
   }
   FIProp->Free();
}
//---------------------------------------------------------------------------
void CI::FUNKCIJA(int index, int end, long double DT)
{
/*
	if(index == 0)
   	Out[index] = C0*DT*In[index]/complex <long double>(2.0,0.0);
   else
   	Out[index] = Out[index-1]+C0*DT/complex <long double>(2.0,0.0)*(In[index]+In[index-1]);
*/
	if(!index)
   	Out[index] = 0.0;
   else
   	Out[index] = C0*DT*In[index - 1] + Out[index - 1];
}
//---------------------------------------------------------------------------
void __fastcall CI::GetDump(void *&Dump, DWORD &DumpSize)
{
	CStdElement::GetDump(Dump, DumpSize);
   AddValue(Dump, DumpSize, &C0, sizeof(long double));
}
//---------------------------------------------------------------------------
void __fastcall CI::SetDump(void *&Dump, DWORD &DumpSize)
{
	CStdElement::SetDump(Dump, DumpSize);
   GetValue(Dump, DumpSize, &C0, sizeof(long double));
}
//---------------------------------------------------------------------------
