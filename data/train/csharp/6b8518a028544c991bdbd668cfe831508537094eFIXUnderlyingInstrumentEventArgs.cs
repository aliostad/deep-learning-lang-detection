using System;
using System.Runtime.CompilerServices;

namespace FreeQuant.FIX
{
  public class FIXUnderlyingInstrumentEventArgs : EventArgs
  {
    private FIXUnderlyingInstrument BNltUIOhEh;

    public FIXUnderlyingInstrument UnderlyingInstrument
    {
      [MethodImpl(MethodImplOptions.NoInlining)] get
      {
        return this.BNltUIOhEh;
      }
      [MethodImpl(MethodImplOptions.NoInlining)] set
      {
        this.BNltUIOhEh = value;
      }
    }

    [MethodImpl(MethodImplOptions.NoInlining)]
    public FIXUnderlyingInstrumentEventArgs(FIXUnderlyingInstrument UnderlyingInstrument)
    {
      this.BNltUIOhEh = UnderlyingInstrument;
    }
  }
}
