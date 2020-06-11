//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop

#include "MCRest.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
//---------------------------------------------------------------------------
CRest::CRest(void):CStdElement()
{
   ID_OBJECT = ID_REST;
	B = 1.0;
   K = 1.0;
   dX = 0.0;
   dY = 0.0;
   ElName = "Îãðàíè÷åíèå";
   FRestProp = NULL;
}
//---------------------------------------------------------------------------
void __fastcall CRest::SetData(void)
{
	FRestProp = new TFRestProp(Application);
   FRestProp->EB->Text = FloatToStr(B);
   FRestProp->EK->Text = FloatToStr(K);
   FRestProp->EdX->Text = FloatToStr(dX);
   FRestProp->EdY->Text = FloatToStr(dY);
   FRestProp->ShowModal();
   if(FRestProp->ResultOk)
   {
   	B = FRestProp->B;
   	K = FRestProp->K;
   	dX = FRestProp->dX;
   	dY = FRestProp->dY;
   }
   FRestProp->Free();
}
//---------------------------------------------------------------------------
void CRest::FUNKCIJA(int index, int end, long double DT)
{
   if(K == 0) K = 1.0;
   long double b = fabs(B/(2.0*K)), dB = 1.0, dK = 1.0;
	long double X = real(In[index]) - dX;
   if(K < 0) dB = -1.0;
   if(B < 0) dK = -1.0;
   if(fabs(X) <= b) Out[index] = K*dK*X;
   if(X > b) Out[index] = B*dB/2.0;
   if(X < -b) Out[index] = -B*dB/2.0;
   Out[index] += dY;
}
//---------------------------------------------------------------------------
void __fastcall CRest::GetDump(void *&Dump, DWORD &DumpSize)
{
	CStdElement::GetDump(Dump, DumpSize);
   AddValue(Dump, DumpSize, &B, sizeof(long double));
   AddValue(Dump, DumpSize, &K, sizeof(long double));
   AddValue(Dump, DumpSize, &dX, sizeof(long double));
   AddValue(Dump, DumpSize, &dY, sizeof(long double));
}
//---------------------------------------------------------------------------
void __fastcall CRest::SetDump(void *&Dump, DWORD &DumpSize)
{
	CStdElement::SetDump(Dump, DumpSize);
   GetValue(Dump, DumpSize, &B, sizeof(long double));
   GetValue(Dump, DumpSize, &K, sizeof(long double));
   GetValue(Dump, DumpSize, &dX, sizeof(long double));
   GetValue(Dump, DumpSize, &dY, sizeof(long double));
}
//---------------------------------------------------------------------------
