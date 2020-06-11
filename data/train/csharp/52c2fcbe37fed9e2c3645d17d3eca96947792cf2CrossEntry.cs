using FreeQuant;
using FreeQuant.Execution;
using FreeQuant.FIX;
using FreeQuant.Instruments;
using FreeQuant.Simulation;
using System;

namespace FreeQuant.Trading
{
	[StrategyComponent("{664274F3-FDE1-46da-A84F-556E4A0EB170}", ComponentType.CrossEntry, Description = "", Name = "Default_CrossEntry")]
	public class CrossEntry : StrategyMultiComponent
	{
		public const string GUID = "{664274F3-FDE1-46da-A84F-556E4A0EB170}";

		public CrossEntry() : base()
		{
		}

		public virtual SingleOrder EmitSignal(Signal signal)
		{
			return this.Strategy.BgvpSPpUAD(signal);
		}

		public virtual SingleOrder LongEntry(Instrument instrument, string text)
		{
			if (!this.Strategy.IsInstrumentActive(instrument))
				return null;
			else
				return this.Strategy.BgvpSPpUAD(new Signal(DateTime.Now, ComponentType.CrossEntry, SignalType.Market, SignalSide.Buy, instrument, text));
		}

		public virtual SingleOrder LongEntry(Instrument instrument)
		{
			return this.LongEntry(instrument, this.Strategy.Name);
		}

		public virtual SingleOrder ShortEntry(Instrument instrument, string text)
		{
			if (!this.Strategy.IsInstrumentActive(instrument))
				return (SingleOrder)null;
			else
				return this.Strategy.BgvpSPpUAD(new Signal(Clock.Now, ComponentType.CrossEntry, SignalType.Market, SignalSide.SellShort, instrument, text));
		}

		public virtual SingleOrder ShortEntry(Instrument instrument)
		{
			return this.ShortEntry(instrument, this.Strategy.Name);
		}

		public virtual SingleOrder LongEntry(Instrument instrument, double price, string text)
		{
			if (!this.Strategy.IsInstrumentActive(instrument))
				return (SingleOrder)null;
			return this.Strategy.BgvpSPpUAD(new Signal(Clock.Now, ComponentType.CrossEntry, SignalType.Market, SignalSide.Buy, instrument, text)
			{
				StrategyFill = true,
				StrategyPrice = price
			});
		}

		public virtual SingleOrder LongEntry(Instrument instrument, double price)
		{
			return this.LongEntry(instrument, price, this.Strategy.Name);
		}

		public virtual SingleOrder ShortEntry(Instrument instrument, double price, string text)
		{
			if (!this.Strategy.IsInstrumentActive(instrument))
				return (SingleOrder)null;
			return this.Strategy.BgvpSPpUAD(new Signal(Clock.Now, ComponentType.CrossEntry, SignalType.Market, SignalSide.SellShort, instrument, text)
			{
				StrategyFill = true,
				StrategyPrice = price
			});
		}

		public virtual SingleOrder ShortEntry(Instrument instrument, double price)
		{
			return this.ShortEntry(instrument, price, this.Strategy.Name);
		}

		public virtual SingleOrder LongEntry(Instrument instrument, FillOnBarMode mode, string text)
		{
			if (!this.Strategy.IsInstrumentActive(instrument))
				return (SingleOrder)null;
			return this.Strategy.BgvpSPpUAD(new Signal(Clock.Now, ComponentType.CrossEntry, SignalType.Market, SignalSide.Buy, instrument, text)
			{
				Fuwj5CvMiW = true,
				R2djQy947W = mode
			});
		}

		public virtual SingleOrder LongEntry(Instrument instrument, FillOnBarMode mode)
		{
			return this.LongEntry(instrument, mode, this.Strategy.Name);
		}

		public virtual SingleOrder ShortEntry(Instrument instrument, FillOnBarMode mode, string text)
		{
			if (!this.Strategy.IsInstrumentActive(instrument))
				return (SingleOrder)null;
			return this.Strategy.BgvpSPpUAD(new Signal(Clock.Now, ComponentType.CrossEntry, SignalType.Market, SignalSide.SellShort, instrument, text)
			{
				Fuwj5CvMiW = true,
				R2djQy947W = mode
			});
		}

		public virtual SingleOrder ShortEntry(Instrument instrument, FillOnBarMode mode)
		{
			return this.ShortEntry(instrument, mode, this.Strategy.Name);
		}

		public virtual SingleOrder Buy(Instrument instrument, string text)
		{
			if (!this.Strategy.IsInstrumentActive(instrument))
				return (SingleOrder)null;
			else
				return this.Strategy.BgvpSPpUAD(new Signal(Clock.Now, ComponentType.CrossEntry, SignalType.Market, SignalSide.Buy, instrument, text));
		}

		public virtual SingleOrder Buy(Instrument instrument)
		{
			return this.Buy(instrument, this.Strategy.Name);
		}

		public virtual SingleOrder Buy(Instrument instrument, double price, string text)
		{
			if (!this.Strategy.IsInstrumentActive(instrument))
				return (SingleOrder)null;
			return this.Strategy.BgvpSPpUAD(new Signal(Clock.Now, ComponentType.CrossEntry, SignalType.Market, SignalSide.Buy, instrument, text)
			{
				StrategyFill = true,
				StrategyPrice = price
			});
		}

		public virtual SingleOrder Buy(Instrument instrument, double price)
		{
			return this.Buy(instrument, price, this.Strategy.Name);
		}

		public virtual SingleOrder Buy(Instrument instrument, FillOnBarMode mode, string text)
		{
			if (!this.Strategy.IsInstrumentActive(instrument))
				return (SingleOrder)null;
			return this.Strategy.BgvpSPpUAD(new Signal(Clock.Now, ComponentType.CrossEntry, SignalType.Market, SignalSide.Buy, instrument, text)
			{
				Fuwj5CvMiW = true,
				R2djQy947W = mode
			});
		}

		public virtual SingleOrder Buy(Instrument instrument, FillOnBarMode mode)
		{
			return this.Buy(instrument, mode, this.Strategy.Name);
		}

		public virtual SingleOrder BuyMarket(Instrument instrument, string text)
		{
			if (!this.Strategy.IsInstrumentActive(instrument))
				return (SingleOrder)null;
			return this.Strategy.BgvpSPpUAD(new Signal(Clock.Now, ComponentType.CrossEntry, SignalType.Market, SignalSide.Buy, instrument, text)
			{
				QvSj2cjRxv = true
			});
		}

		public virtual SingleOrder BuyMarket(Instrument instrument)
		{
			return this.Buy(instrument, this.Strategy.Name);
		}

		public virtual SingleOrder BuyLimit(Instrument instrument, double price, TimeInForce timeInForce, string text)
		{
			if (!this.Strategy.IsInstrumentActive(instrument))
				return (SingleOrder)null;
			return this.Strategy.BgvpSPpUAD(new Signal(Clock.Now, ComponentType.CrossEntry, SignalType.Limit, SignalSide.Buy, instrument, text)
			{
				LimitPrice = price,
				TimeInForce = timeInForce
			});
		}

		public virtual SingleOrder BuyLimit(Instrument instrument, double price, string text)
		{
			return this.BuyLimit(instrument, price, TimeInForce.GTC, text);
		}

		public virtual SingleOrder BuyLimit(Instrument instrument, double price, TimeInForce timeInForce)
		{
			return this.BuyLimit(instrument, price, timeInForce, this.Strategy.Name);
		}

		public virtual SingleOrder BuyLimit(Instrument instrument, double price)
		{
			return this.BuyLimit(instrument, price, this.Strategy.Name);
		}

		public virtual SingleOrder BuyStop(Instrument instrument, double price, string text)
		{
			if (!this.Strategy.IsInstrumentActive(instrument))
				return (SingleOrder)null;
			return this.Strategy.BgvpSPpUAD(new Signal(Clock.Now, ComponentType.CrossEntry, SignalType.Stop, SignalSide.Buy, instrument, text)
			{
				StopPrice = price
			});
		}

		public virtual SingleOrder BuyStop(Instrument instrument, double price)
		{
			return this.BuyStop(instrument, price, this.Strategy.Name);
		}

		public virtual SingleOrder BuyStopLimit(Instrument instrument, double stopPrice, double limitPrice, string text)
		{
			if (!this.Strategy.IsInstrumentActive(instrument))
				return (SingleOrder)null;
			return this.Strategy.BgvpSPpUAD(new Signal(Clock.Now, ComponentType.CrossEntry, SignalType.StopLimit, SignalSide.Buy, instrument, text)
			{
				StopPrice = stopPrice,
				LimitPrice = limitPrice
			});
		}

		public virtual SingleOrder BuyStopLimit(Instrument instrument, double stopPrice, double limitPrice)
		{
			return this.BuyStopLimit(instrument, stopPrice, limitPrice, this.Strategy.Name);
		}

		public virtual SingleOrder BuyTrailingStop(Instrument instrument, double delta, string text)
		{
			if (!this.Strategy.IsInstrumentActive(instrument))
				return (SingleOrder)null;
			return this.Strategy.BgvpSPpUAD(new Signal(Clock.Now, ComponentType.CrossEntry, SignalType.TrailingStop, SignalSide.Buy, instrument, text)
			{
				StopPrice = delta
			});
		}

		public virtual SingleOrder BuyTrailingStop(Instrument instrument, double delta)
		{
			return this.BuyTrailingStop(instrument, delta, string.Format("dfs", this.Strategy.Name));
		}

		public virtual SingleOrder Sell(Instrument instrument, string text)
		{
			if (!this.Strategy.IsInstrumentActive(instrument))
				return (SingleOrder)null;
			else
				return this.Strategy.BgvpSPpUAD(new Signal(Clock.Now, ComponentType.CrossEntry, SignalType.Market, SignalSide.Sell, instrument, text));
		}

		public virtual SingleOrder Sell(Instrument instrument)
		{
			return this.Sell(instrument, this.Strategy.Name);
		}

		public virtual SingleOrder Sell(Instrument instrument, double price, string text)
		{
			if (!this.Strategy.IsInstrumentActive(instrument))
				return (SingleOrder)null;
			return this.Strategy.BgvpSPpUAD(new Signal(Clock.Now, ComponentType.CrossEntry, SignalType.Market, SignalSide.Sell, instrument, text)
			{
				StrategyFill = true,
				StrategyPrice = price
			});
		}

		public virtual SingleOrder Sell(Instrument instrument, double price)
		{
			return this.Sell(instrument, price, this.Strategy.Name);
		}

		public virtual SingleOrder Sell(Instrument instrument, FillOnBarMode mode, string text)
		{
			if (!this.Strategy.IsInstrumentActive(instrument))
				return (SingleOrder)null;
			return this.Strategy.BgvpSPpUAD(new Signal(Clock.Now, ComponentType.CrossEntry, SignalType.Market, SignalSide.Sell, instrument, text)
			{
				Fuwj5CvMiW = true,
				R2djQy947W = mode
			});
		}

		public virtual SingleOrder Sell(Instrument instrument, FillOnBarMode mode)
		{
			return this.Sell(instrument, mode, this.Strategy.Name);
		}

		public virtual SingleOrder SellMarket(Instrument instrument, string text)
		{
			if (!this.Strategy.IsInstrumentActive(instrument))
				return (SingleOrder)null;
			return this.Strategy.BgvpSPpUAD(new Signal(Clock.Now, ComponentType.CrossEntry, SignalType.Market, SignalSide.Sell, instrument, text)
			{
				QvSj2cjRxv = true
			});
		}

		public virtual SingleOrder SellMarket(Instrument instrument)
		{
			return this.Sell(instrument, this.Strategy.Name);
		}

		public virtual SingleOrder SellLimit(Instrument instrument, double price, string text)
		{
			if (!this.Strategy.IsInstrumentActive(instrument))
				return (SingleOrder)null;
			return this.Strategy.BgvpSPpUAD(new Signal(Clock.Now, ComponentType.CrossEntry, SignalType.Limit, SignalSide.Sell, instrument, text)
			{
				LimitPrice = price
			});
		}

		public virtual SingleOrder SellLimit(Instrument instrument, double price)
		{
			return this.SellLimit(instrument, price, this.Strategy.Name);
		}

		public virtual SingleOrder SellStop(Instrument instrument, double price, string text)
		{
			if (!this.Strategy.IsInstrumentActive(instrument))
				return (SingleOrder)null;
			return this.Strategy.BgvpSPpUAD(new Signal(Clock.Now, ComponentType.CrossEntry, SignalType.Stop, SignalSide.Sell, instrument, text)
			{
				StopPrice = price
			});
		}

		public virtual SingleOrder SellStop(Instrument instrument, double price)
		{
			return this.SellStop(instrument, price, this.Strategy.Name);
		}

		public virtual SingleOrder SellStopLimit(Instrument instrument, double stopPrice, double limitPrice, string text)
		{
			if (!this.Strategy.IsInstrumentActive(instrument))
				return (SingleOrder)null;
			return this.Strategy.BgvpSPpUAD(new Signal(Clock.Now, ComponentType.CrossEntry, SignalType.StopLimit, SignalSide.Sell, instrument, text)
			{
				StopPrice = stopPrice,
				LimitPrice = limitPrice
			});
		}

		public virtual SingleOrder SellStopLimit(Instrument instrument, double stopPrice, double limitPrice)
		{
			return this.SellStopLimit(instrument, stopPrice, limitPrice, this.Strategy.Name);
		}

		public virtual SingleOrder SellTrailingStop(Instrument instrument, double delta, string text)
		{
			if (!this.Strategy.IsInstrumentActive(instrument))
				return (SingleOrder)null;
			return this.Strategy.BgvpSPpUAD(new Signal(Clock.Now, ComponentType.CrossEntry, SignalType.TrailingStop, SignalSide.Sell, instrument, text)
			{
				StopPrice = delta
			});
		}

		public virtual SingleOrder SellTrailingStop(Instrument instrument, double delta)
		{
			return this.SellTrailingStop(instrument, delta, string.Format("dsd", this.Strategy.Name));
		}

		public virtual SingleOrder SellShort(Instrument instrument, string text)
		{
			if (!this.Strategy.IsInstrumentActive(instrument))
				return (SingleOrder)null;
			else
				return this.Strategy.BgvpSPpUAD(new Signal(Clock.Now, ComponentType.CrossEntry, SignalType.Market, SignalSide.SellShort, instrument, text));
		}

		public virtual SingleOrder SellShort(Instrument instrument)
		{
			return this.SellShort(instrument, this.Strategy.Name);
		}

		public virtual SingleOrder SellShort(Instrument instrument, FillOnBarMode mode, string text)
		{
			if (!this.Strategy.IsInstrumentActive(instrument))
				return (SingleOrder)null;
			return this.Strategy.BgvpSPpUAD(new Signal(Clock.Now, ComponentType.CrossEntry, SignalType.Market, SignalSide.SellShort, instrument, text)
			{
				Fuwj5CvMiW = true,
				R2djQy947W = mode
			});
		}

		public virtual SingleOrder SellShort(Instrument instrument, FillOnBarMode mode)
		{
			return this.SellShort(instrument, mode, this.Strategy.Name);
		}
	}
}
