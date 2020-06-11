using FreeQuant.FIX;
using FreeQuant.Instruments;
using FreeQuant.Providers;

namespace OpenQuant.Shared.TradingTools
{
  class InstrumentProviderKey
  {
    private string key;

    public Instrument Instrument { get; private set; }

    public IProvider Provider { get; private set; }

    public InstrumentProviderKey(Instrument instrument, IProvider provider)
    {
      this.Instrument = instrument;
      this.Provider = provider;
			this.key = string.Format("{0}[{1}]", (object) ((FIXInstrument) instrument).Symbol, provider.Name);
    }

    public override int GetHashCode()
    {
      return this.key.GetHashCode();
    }

    public override bool Equals(object obj)
    {
      if (obj is InstrumentProviderKey)
        return this.key.Equals(((InstrumentProviderKey) obj).key);
      else
        return base.Equals(obj);
    }
  }
}
