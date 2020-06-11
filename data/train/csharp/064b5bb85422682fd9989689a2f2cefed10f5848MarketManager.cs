using FreeQuant.Instruments;
using FreeQuant.Providers;
using System;
using System.Collections.Generic;
using System.ComponentModel;

namespace FreeQuant.Trading
{
	[StrategyComponent("{849E4CFE-C19E-4d1e-899D-0BB26DB12AAD}", ComponentType.MarketManager, Description = "", Name = "Default_MarketManager")]
	public class MarketManager : StrategyBaseMultiComponent
	{
		public const string GUID = "{849E4CFE-C19E-4d1e-899D-0BB26DB12AAD}";
		private Dictionary<Instrument, IMarketDataProvider> nxTAjlViDK;
		private Dictionary<Instrument, IExecutionProvider> utDAWNS3ic;
		private InstrumentList cYRAR9UWJy;
		protected IMarketDataProvider strategyMarketDataProvider;
		protected IExecutionProvider strategyExecutionProvider;

		[Browsable(false)]
		public InstrumentList Instruments
		{
			get
			{
				return this.cYRAR9UWJy;
			}
		}

		[Browsable(false)]
		internal IMarketDataProvider OM26eKMfqS
		{
			get
			{
				return this.strategyMarketDataProvider;
			}
			set
			{
				this.strategyMarketDataProvider = value;
			}
		}

		[Browsable(false)]
		internal IExecutionProvider TOY6zSGlVT
		{
			get
			{
				return this.strategyExecutionProvider;
			}
			set
			{
				this.strategyExecutionProvider = value;
			}
		}

		[Browsable(false)]
		internal Dictionary<Instrument, IMarketDataProvider> jcIApP7GcT
		{
			get
			{
				return this.nxTAjlViDK;
			}
		}

		[Browsable(false)]
		internal Dictionary<Instrument, IExecutionProvider> UyiAAd6ITD
		{
			get
			{
				return this.utDAWNS3ic;
			}
		}

		public MarketManager() : base()
		{
			this.nxTAjlViDK = new Dictionary<Instrument, IMarketDataProvider>();
			this.utDAWNS3ic = new Dictionary<Instrument, IExecutionProvider>();
			this.cYRAR9UWJy = new InstrumentList();
		}

		public void AddInstrument(Instrument instrument, IMarketDataProvider marketDataProvider, IExecutionProvider executionProvider)
		{
			if (!this.cYRAR9UWJy.Contains(instrument))
				this.cYRAR9UWJy.Add(instrument);
			this.nxTAjlViDK[instrument] = marketDataProvider == null ? this.strategyMarketDataProvider : marketDataProvider;
			if (executionProvider != null)
				this.utDAWNS3ic[instrument] = executionProvider;
			else
				this.utDAWNS3ic[instrument] = this.strategyExecutionProvider;
		}

		public void AddInstrument(Instrument instrument, string marketDataProviderName, string executionProviderName)
		{
			IMarketDataProvider marketDataProvider = ProviderManager.MarketDataProviders[marketDataProviderName];
			IExecutionProvider executionProvider = ProviderManager.ExecutionProviders[executionProviderName];
			if (marketDataProvider == null && marketDataProviderName != "")
				throw new InvalidOperationException(instrument.Symbol);
			if (executionProvider == null && executionProviderName != "")
				throw new InvalidOperationException(instrument.Symbol);
			this.AddInstrument(instrument, marketDataProvider, executionProvider);
		}

		public void AddInstrument(string symbol, string marketDataProviderName, string executionProviderName)
		{
			Instrument instrument = InstrumentManager.Instruments[symbol];
			if (instrument == null)
				return;
			this.AddInstrument(instrument, marketDataProviderName, executionProviderName);
		}

		public void AddInstrument(Instrument instrument)
		{
			this.AddInstrument(instrument, this.strategyMarketDataProvider, this.strategyExecutionProvider);
		}

		public void AddInstrument(string symbol)
		{
			Instrument instrument = InstrumentManager.Instruments[symbol];
			if (instrument == null)
				return;
			this.AddInstrument(instrument);
		}

		public void RemoveInstrument(Instrument instrument)
		{
			this.cYRAR9UWJy.Remove(instrument);
			this.nxTAjlViDK.Remove(instrument);
			this.utDAWNS3ic.Remove(instrument);
		}

		public void RemoveInstrument(string symbol)
		{
			Instrument instrument = InstrumentManager.Instruments[symbol];
			if (instrument == null)
				return;
			this.RemoveInstrument(instrument);
		}
	}
}
