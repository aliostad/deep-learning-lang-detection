//---------------------------------------------------------------------------
#include <vcl.h>
#pragma hdrstop

#include "MCSinus.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
//---------------------------------------------------------------------------
CSinus::CSinus(void):CStdElement()
{
   ID_OBJECT = ID_SINUS;
	A = 1.0;
   W = 1.0;
   F = 0.0;
   GradToRadians = M_PI/180.0;
   dX = 0.0;
   dY = 0.0;
   ElName = "Ñèíóñîèäà";
   FSinProp = NULL;
}
//---------------------------------------------------------------------------
void __fastcall CSinus::SetData(void)
{
	FSinProp = new TFSinProp(Application);
   if(GradToRadians == 1.0)
   	FSinProp->RGCorner->ItemIndex = 1;
   else
   	FSinProp->RGCorner->ItemIndex = 0;
   FSinProp->EA->Text = FloatToStr(A);
   FSinProp->EW->Text = FloatToStr(W);
   FSinProp->EF->Text = FloatToStr(F);
   FSinProp->EdX->Text = FloatToStr(dX);
   FSinProp->EdY->Text = FloatToStr(dY);
   FSinProp->ShowModal();
   if(FSinProp->ResultOk)
   {
      if(FSinProp->RGCorner->ItemIndex == 0)
   		GradToRadians = M_PI/180.0;
      else
   		GradToRadians = 1.0;
   	A = FSinProp->A;
   	W = FSinProp->W;
   	F = FSinProp->F;
   	dX = FSinProp->dX;
   	dY = FSinProp->dY;
   }
   FSinProp->Free();
}
//---------------------------------------------------------------------------
void CSinus::FUNKCIJA(int index, int end, long double DT)
{
	long double X = real(In[index]) - dX;
   Out[index] = A*sin(X*W + F*GradToRadians);
   Out[index] += dY;
}
//---------------------------------------------------------------------------
void __fastcall CSinus::GetDump(void *&Dump, DWORD &DumpSize)
{
	CStdElement::GetDump(Dump, DumpSize);
   AddValue(Dump, DumpSize, &A, sizeof(long double));
   AddValue(Dump, DumpSize, &W, sizeof(long double));
   AddValue(Dump, DumpSize, &F, sizeof(long double));
   AddValue(Dump, DumpSize, &GradToRadians, sizeof(long double));
   AddValue(Dump, DumpSize, &dX, sizeof(long double));
   AddValue(Dump, DumpSize, &dY, sizeof(long double));
}
//---------------------------------------------------------------------------
void __fastcall CSinus::SetDump(void *&Dump, DWORD &DumpSize)
{
	CStdElement::SetDump(Dump, DumpSize);
   GetValue(Dump, DumpSize, &A, sizeof(long double));
   GetValue(Dump, DumpSize, &W, sizeof(long double));
   GetValue(Dump, DumpSize, &F, sizeof(long double));
   GetValue(Dump, DumpSize, &GradToRadians, sizeof(long double));
   GetValue(Dump, DumpSize, &dX, sizeof(long double));
   GetValue(Dump, DumpSize, &dY, sizeof(long double));
}
//---------------------------------------------------------------------------
