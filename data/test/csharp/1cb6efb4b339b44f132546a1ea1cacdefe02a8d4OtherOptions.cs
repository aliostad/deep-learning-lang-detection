// Type: OpenQuant.Shared.Data.Import.CSV.OtherOptions
// Assembly: OpenQuant.Shared, Version=1.0.5037.20293, Culture=neutral, PublicKeyToken=null
// MVID: A690BAEF-D039-46EF-A391-4A4F5A74669E
// Assembly location: E:\OpenQuant\Bin\OpenQuant.Shared.dll

using OpenQuant.API;
using System;

namespace OpenQuant.Shared.Data.Import.CSV
{
  internal class OtherOptions
  {
    private bool createInstrument;
    private bool clearSeries;
    private InstrumentType instrumentType;

    public bool ImportOnlyRange { get; set; }

    public DateTime ImportRangeBegin { get; set; }

    public DateTime ImportRangeEnd { get; set; }

    public bool SkipDataInsideExistingRange { get; set; }

    public bool CreateInstrument
    {
      get
      {
        return this.createInstrument;
      }
      set
      {
        this.createInstrument = value;
      }
    }

    public bool ClearSeries
    {
      get
      {
        return this.clearSeries;
      }
      set
      {
        this.clearSeries = value;
      }
    }

    public InstrumentType InstrumentType
    {
      get
      {
        return this.instrumentType;
      }
      set
      {
        this.instrumentType = value;
      }
    }

    public OtherOptions()
    {
      this.createInstrument = true;
      this.clearSeries = false;
      this.instrumentType = InstrumentType.Stock;
    }
  }
}
