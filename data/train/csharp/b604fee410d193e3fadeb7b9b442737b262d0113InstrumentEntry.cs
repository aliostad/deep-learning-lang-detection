using FreeQuant.Instruments;
using FreeQuant.Series;
using System.Collections.Generic;

namespace OpenQuant.Shared.Instruments
{
  public class InstrumentEntry
  {
    private Instrument instrument;
    private List<BarSeries> seriesList;

    public Instrument Instrument
    {
      get
      {
        return this.instrument;
      }
    }

    public List<BarSeries> SeriesList
    {
      get
      {
        return this.seriesList;
      }
    }

    public InstrumentEntry(Instrument instrument)
    {
      this.instrument = instrument;
      this.seriesList = new List<BarSeries>();
    }
  }
}
