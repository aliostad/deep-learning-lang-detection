//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop

#include "MCNoSenseRest.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
//---------------------------------------------------------------------------
CNoSenseRest::CNoSenseRest(void):CStdElement()
{
   ID_OBJECT = ID_NOSENSEREST;
	A = 1.0;
   B = 1.0;
   K = 1.0;
   dX = 0.0;
   dY = 0.0;
   ElName = "Íå÷óâñòâèòåëüíîñòü è îãðàíè÷åíèå";
   FNoSenseRestProp = NULL;
}
//---------------------------------------------------------------------------
void __fastcall CNoSenseRest::SetData(void)
{
	FNoSenseRestProp = new TFNoSenseRestProp(Application);
   FNoSenseRestProp->EA->Text = FloatToStr(A);
   FNoSenseRestProp->EB->Text = FloatToStr(B);
   FNoSenseRestProp->EK->Text = FloatToStr(K);
   FNoSenseRestProp->EdX->Text = FloatToStr(dX);
   FNoSenseRestProp->EdY->Text = FloatToStr(dY);
   FNoSenseRestProp->ShowModal();
   if(FNoSenseRestProp->ResultOk)
   {
   	A = FNoSenseRestProp->A;
   	B = FNoSenseRestProp->B;
   	K = FNoSenseRestProp->K;
   	dX = FNoSenseRestProp->dX;
   	dY = FNoSenseRestProp->dY;
   }
   FNoSenseRestProp->Free();
}
//---------------------------------------------------------------------------
void CNoSenseRest::FUNKCIJA(int index, int end, long double DT)
{
   if(K == 0) K = 1.0;
   long double a = fabs(A/2.0);
   long double b = fabs(B/(2.0*K)), dB = 1.0, dK = 1.0;
   long double X = real(In[index]) - dX;
   if(K < 0) dB = -1.0;
   if(B < 0) dK = -1.0;
	if(fabs(X) <= a) Out[index] = 0.0;
   if(X > a && X <= b + a) Out[index] = K*dK*(X - a);
   if(X > b + a) Out[index] = B*dB/2.0;
   if(X < -a && X >= -(b + a)) Out[index] = K*dK*(X + a);
   if(X < -(b + a)) Out[index] = -B*dB/2.0;
   Out[index] += dY;
}
//---------------------------------------------------------------------------
void __fastcall CNoSenseRest::GetDump(void *&Dump, DWORD &DumpSize)
{
	CStdElement::GetDump(Dump, DumpSize);
   AddValue(Dump, DumpSize, &A, sizeof(long double));
   AddValue(Dump, DumpSize, &B, sizeof(long double));
   AddValue(Dump, DumpSize, &K, sizeof(long double));
   AddValue(Dump, DumpSize, &dX, sizeof(long double));
   AddValue(Dump, DumpSize, &dY, sizeof(long double));
}
//---------------------------------------------------------------------------
void __fastcall CNoSenseRest::SetDump(void *&Dump, DWORD &DumpSize)
{
	CStdElement::SetDump(Dump, DumpSize);
   GetValue(Dump, DumpSize, &A, sizeof(long double));
   GetValue(Dump, DumpSize, &B, sizeof(long double));
   GetValue(Dump, DumpSize, &K, sizeof(long double));
   GetValue(Dump, DumpSize, &dX, sizeof(long double));
   GetValue(Dump, DumpSize, &dY, sizeof(long double));
}
//---------------------------------------------------------------------------
