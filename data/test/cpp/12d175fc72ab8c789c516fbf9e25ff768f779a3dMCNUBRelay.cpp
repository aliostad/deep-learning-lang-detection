//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop

#include "MCNUBRelay.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
//---------------------------------------------------------------------------
CNUBRelay::CNUBRelay(void):CStdElement()
{
   ID_OBJECT = ID_NUBRELAY;
   A = 1.0;
   B = 1.0;
   dX = 0.0;
   dY = 0.0;
   ElName = "Íåîäíîçíà÷íîå ðåëå";
   FNUBRelayProp = NULL;
}
//---------------------------------------------------------------------------
void __fastcall CNUBRelay::SetData(void)
{
	FNUBRelayProp = new TFNUBRelayProp(Application);
   FNUBRelayProp->EA->Text = FloatToStr(A);
   FNUBRelayProp->EB->Text = FloatToStr(B);
   FNUBRelayProp->EdX->Text = FloatToStr(dX);
   FNUBRelayProp->EdY->Text = FloatToStr(dY);
   FNUBRelayProp->ShowModal();
   if(FNUBRelayProp->ResultOk)
   {
   	A = FNUBRelayProp->A;
   	B = FNUBRelayProp->B;
   	dX = FNUBRelayProp->dX;
   	dY = FNUBRelayProp->dY;
   }
   FNUBRelayProp->Free();
}
//---------------------------------------------------------------------------
void CNUBRelay::FUNKCIJA(int index, int end, long double DT)
{
   long double a = fabs(A/2.0);
   long double X = real(In[index]) - dX;
   if(X > a) Out[index] = B/2.0;
   if(fabs(X) <= a)
   {
      long double OldX;
      if(index == 0) OldX = X; else OldX = real(In[index - 1]);
      if(OldX <= X) Out[index] = -B/2.0; else Out[index] = B/2.0;
   }
   if(X < -a) Out[index] = -B/2.0;
   Out[index] += dY;
}
//---------------------------------------------------------------------------
void __fastcall CNUBRelay::GetDump(void *&Dump, DWORD &DumpSize)
{
	CStdElement::GetDump(Dump, DumpSize);
   AddValue(Dump, DumpSize, &A, sizeof(long double));
   AddValue(Dump, DumpSize, &B, sizeof(long double));
   AddValue(Dump, DumpSize, &dX, sizeof(long double));
   AddValue(Dump, DumpSize, &dY, sizeof(long double));
}
//---------------------------------------------------------------------------
void __fastcall CNUBRelay::SetDump(void *&Dump, DWORD &DumpSize)
{
	CStdElement::SetDump(Dump, DumpSize);
   GetValue(Dump, DumpSize, &A, sizeof(long double));
   GetValue(Dump, DumpSize, &B, sizeof(long double));
   GetValue(Dump, DumpSize, &dX, sizeof(long double));
   GetValue(Dump, DumpSize, &dY, sizeof(long double));
}
//---------------------------------------------------------------------------
