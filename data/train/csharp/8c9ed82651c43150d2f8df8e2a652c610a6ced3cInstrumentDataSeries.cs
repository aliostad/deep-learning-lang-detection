using FreeQuant.Data;
using FreeQuant.Instruments;

namespace OpenQuant.Shared.Data.Management
{
  internal class InstrumentDataSeries
  {
    public Instrument Instrument { get; private set; }

    public IDataSeries DataSeries { get; private set; }

    public DataTypeItem DataTypeItem { get; private set; }

    public InstrumentDataSeries(Instrument instrument, IDataSeries dataSeries, DataTypeItem dataTypeItem)
    {
      this.Instrument = instrument;
      this.DataSeries = dataSeries;
      this.DataTypeItem = dataTypeItem;
    }
  }
}
