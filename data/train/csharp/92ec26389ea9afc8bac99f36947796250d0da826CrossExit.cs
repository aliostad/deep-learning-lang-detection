using FreeQuant;
using FreeQuant.Execution;
using FreeQuant.Instruments;
using FreeQuant.Simulation;

namespace FreeQuant.Trading
{
  [StrategyComponent("{D779BA8E-C0CA-44cf-8745-99105365882F}", ComponentType.CrossExit, Description = "", Name = "Default_CrossExit")]
  public class CrossExit : StrategyMultiComponent
  {
    public const string GUID = "{D779BA8E-C0CA-44cf-8745-99105365882F}";


    
    public virtual SingleOrder EmitSignal(Signal signal)
    {
      return this.Strategy.BgvpSPpUAD(signal);
    }

    
    public virtual SingleOrder LongExit(Instrument instrument, string text)
    {
      if (!this.Strategy.IsInstrumentActive(instrument))
        return (SingleOrder) null;
      Signal signal = new Signal(Clock.Now, ComponentType.CrossExit, SignalType.Market, SignalSide.Sell, instrument, text);
      Position position = this.Portfolio.Positions[instrument];
      if (position == null || position.Side != PositionSide.Long)
      {
        signal.Status = SignalStatus.Rejected;
        signal.Rejecter = ComponentType.CrossExit;
      }
      return this.Strategy.BgvpSPpUAD(signal);
    }

    
    public virtual SingleOrder LongExit(Instrument instrument)
    {
      return this.LongExit(instrument,  this.Strategy.Name);
    }

    
    public virtual SingleOrder ShortExit(Instrument instrument, string text)
    {
      if (!this.Strategy.IsInstrumentActive(instrument))
        return (SingleOrder) null;
      Signal signal = new Signal(Clock.Now, ComponentType.CrossExit, SignalType.Market, SignalSide.BuyCover, instrument, text);
      Position position = this.Portfolio.Positions[instrument];
      if (position == null || position.Side != PositionSide.Short)
      {
        signal.Status = SignalStatus.Rejected;
        signal.Rejecter = ComponentType.CrossExit;
      }
      return this.Strategy.BgvpSPpUAD(signal);
    }

    
    public virtual SingleOrder ShortExit(Instrument instrument)
    {
      return this.ShortExit(instrument, this.Strategy.Name);
    }

    
    public virtual SingleOrder LongExit(Instrument instrument, double price, string text)
    {
      if (!this.Strategy.IsInstrumentActive(instrument))
        return (SingleOrder) null;
      Signal signal = new Signal(Clock.Now, ComponentType.CrossExit, SignalType.Market, SignalSide.Sell, instrument, text);
      signal.StrategyFill = true;
      signal.StrategyPrice = price;
      Position position = this.Portfolio.Positions[instrument];
      if (position == null || position.Side != PositionSide.Long)
      {
        signal.Status = SignalStatus.Rejected;
        signal.Rejecter = ComponentType.CrossExit;
      }
      return this.Strategy.BgvpSPpUAD(signal);
    }

    
    public virtual SingleOrder LongExit(Instrument instrument, double price)
    {
      return this.LongExit(instrument, price, this.Strategy.Name);
    }

    
    public virtual SingleOrder ShortExit(Instrument instrument, double price, string text)
    {
      if (!this.Strategy.IsInstrumentActive(instrument))
        return (SingleOrder) null;
      Signal signal = new Signal(Clock.Now, ComponentType.CrossExit, SignalType.Market, SignalSide.BuyCover, instrument, text);
      signal.StrategyFill = true;
      signal.StrategyPrice = price;
      Position position = this.Portfolio.Positions[instrument];
      if (position == null || position.Side != PositionSide.Short)
      {
        signal.Status = SignalStatus.Rejected;
        signal.Rejecter = ComponentType.CrossExit;
      }
      return this.Strategy.BgvpSPpUAD(signal);
    }

    
    public virtual SingleOrder ShortExit(Instrument instrument, double price)
    {
      return this.ShortExit(instrument, price, this.Strategy.Name);
    }

    
    public virtual SingleOrder LongExit(Instrument instrument, FillOnBarMode mode, string text)
    {
      if (!this.Strategy.IsInstrumentActive(instrument))
        return (SingleOrder) null;
      return this.Strategy.BgvpSPpUAD(new Signal(Clock.Now, ComponentType.CrossExit, SignalType.Market, SignalSide.Sell, instrument, text)
      {
        Fuwj5CvMiW = true,
        R2djQy947W = mode
      });
    }

    
    public virtual SingleOrder LongExit(Instrument instrument, FillOnBarMode mode)
    {
      return this.LongExit(instrument, mode,  this.Strategy.Name);
    }

    
    public virtual SingleOrder ShortExit(Instrument instrument, FillOnBarMode mode, string text)
    {
      if (!this.Strategy.IsInstrumentActive(instrument))
        return (SingleOrder) null;
      return this.Strategy.BgvpSPpUAD(new Signal(Clock.Now, ComponentType.CrossExit, SignalType.Market, SignalSide.BuyCover, instrument, text)
      {
        Fuwj5CvMiW = true,
        R2djQy947W = mode
      });
    }

    
    public virtual SingleOrder ShortExit(Instrument instrument, FillOnBarMode mode)
    {
      return this.ShortExit(instrument, mode, this.Strategy.Name);
    }

    
    public virtual SingleOrder Buy(Instrument instrument, string text)
    {
      if (!this.Strategy.IsInstrumentActive(instrument))
        return (SingleOrder) null;
      else
        return this.Strategy.BgvpSPpUAD(new Signal(Clock.Now, ComponentType.CrossExit, SignalType.Market, SignalSide.Buy, instrument, text));
    }

    
    public virtual SingleOrder Buy(Instrument instrument)
    {
      return this.Buy(instrument, this.Strategy.Name);
    }

    
    public virtual SingleOrder Buy(Instrument instrument, double price, string text)
    {
      if (!this.Strategy.IsInstrumentActive(instrument))
        return (SingleOrder) null;
      return this.Strategy.BgvpSPpUAD(new Signal(Clock.Now, ComponentType.CrossExit, SignalType.Market, SignalSide.Buy, instrument, text)
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
        return (SingleOrder) null;
      return this.Strategy.BgvpSPpUAD(new Signal(Clock.Now, ComponentType.CrossExit, SignalType.Market, SignalSide.Buy, instrument, text)
      {
        Fuwj5CvMiW = true,
        R2djQy947W = mode
      });
    }

    
    public virtual SingleOrder Buy(Instrument instrument, FillOnBarMode mode)
    {
      return this.Buy(instrument, mode, this.Strategy.Name);
    }

    
    public virtual SingleOrder BuyLimit(Instrument instrument, double price, string text)
    {
      if (!this.Strategy.IsInstrumentActive(instrument))
        return (SingleOrder) null;
      return this.Strategy.BgvpSPpUAD(new Signal(Clock.Now, ComponentType.CrossExit, SignalType.Limit, SignalSide.Buy, instrument, text)
      {
        LimitPrice = price
      });
    }

    
    public virtual SingleOrder BuyLimit(Instrument instrument, double price)
    {
      return this.BuyLimit(instrument, price,  this.Strategy.Name);
    }

    
    public virtual SingleOrder BuyStop(Instrument instrument, double price, string text)
    {
      if (!this.Strategy.IsInstrumentActive(instrument))
        return (SingleOrder) null;
      return this.Strategy.BgvpSPpUAD(new Signal(Clock.Now, ComponentType.CrossExit, SignalType.Stop, SignalSide.Buy, instrument, text)
      {
        StopPrice = price
      });
    }

    
    public virtual SingleOrder BuyStop(Instrument instrument, double price)
    {
      return this.BuyStop(instrument, price,  this.Strategy.Name);
    }

    
    public virtual SingleOrder BuyStopLimit(Instrument instrument, double stopPrice, double limitPrice, string text)
    {
      if (!this.Strategy.IsInstrumentActive(instrument))
        return (SingleOrder) null;
      return this.Strategy.BgvpSPpUAD(new Signal(Clock.Now, ComponentType.CrossExit, SignalType.StopLimit, SignalSide.Buy, instrument, text)
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
        return (SingleOrder) null;
      return this.Strategy.BgvpSPpUAD(new Signal(Clock.Now, ComponentType.CrossExit, SignalType.TrailingStop, SignalSide.Buy, instrument, text)
      {
        StopPrice = delta
      });
    }

    
    public virtual SingleOrder BuyTrailingStop(Instrument instrument, double delta)
    {
			return this.BuyTrailingStop(instrument, delta, string.Format("dffs", (object) this.Strategy.Name));
    }

    
    public virtual SingleOrder Sell(Instrument instrument, string text)
    {
      if (!this.Strategy.IsInstrumentActive(instrument))
        return (SingleOrder) null;
      else
        return this.Strategy.BgvpSPpUAD(new Signal(Clock.Now, ComponentType.CrossExit, SignalType.Market, SignalSide.Sell, instrument, text));
    }

    
    public virtual SingleOrder Sell(Instrument instrument)
    {
      return this.Sell(instrument, this.Strategy.Name);
    }

    
    public virtual SingleOrder Sell(Instrument instrument, double price, string text)
    {
      if (!this.Strategy.IsInstrumentActive(instrument))
        return (SingleOrder) null;
      return this.Strategy.BgvpSPpUAD(new Signal(Clock.Now, ComponentType.CrossExit, SignalType.Market, SignalSide.Sell, instrument, text)
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
        return (SingleOrder) null;
      return this.Strategy.BgvpSPpUAD(new Signal(Clock.Now, ComponentType.CrossExit, SignalType.Market, SignalSide.Sell, instrument, text)
      {
        Fuwj5CvMiW = true,
        R2djQy947W = mode
      });
    }

    
    public virtual SingleOrder Sell(Instrument instrument, FillOnBarMode mode)
    {
      return this.Sell(instrument, mode, this.Strategy.Name);
    }

    
    public virtual SingleOrder SellLimit(Instrument instrument, double price, string text)
    {
      if (!this.Strategy.IsInstrumentActive(instrument))
        return (SingleOrder) null;
      return this.Strategy.BgvpSPpUAD(new Signal(Clock.Now, ComponentType.CrossExit, SignalType.Limit, SignalSide.Sell, instrument, text)
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
        return (SingleOrder) null;
      return this.Strategy.BgvpSPpUAD(new Signal(Clock.Now, ComponentType.CrossExit, SignalType.Stop, SignalSide.Sell, instrument, text)
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
        return (SingleOrder) null;
      return this.Strategy.BgvpSPpUAD(new Signal(Clock.Now, ComponentType.CrossExit, SignalType.StopLimit, SignalSide.Sell, instrument, text)
      {
        StopPrice = stopPrice,
        LimitPrice = limitPrice
      });
    }

    
    public virtual SingleOrder SellStopLimit(Instrument instrument, double stopPrice, double limitPrice)
    {
      return this.SellStopLimit(instrument, stopPrice, limitPrice,  this.Strategy.Name);
    }

    
    public virtual SingleOrder SellTrailingStop(Instrument instrument, double delta, string text)
    {
      if (!this.Strategy.IsInstrumentActive(instrument))
        return (SingleOrder) null;
      return this.Strategy.BgvpSPpUAD(new Signal(Clock.Now, ComponentType.CrossExit, SignalType.TrailingStop, SignalSide.Sell, instrument, text)
      {
        StopPrice = delta
      });
    }

    
    public virtual SingleOrder SellTrailingStop(Instrument instrument, double delta)
    {
			return this.SellTrailingStop(instrument, delta, string.Format("dfdfs", (object) this.Strategy.Name));
    }

    
    public virtual SingleOrder SellShort(Instrument instrument, string text)
    {
      if (!this.Strategy.IsInstrumentActive(instrument))
        return (SingleOrder) null;
      else
        return this.Strategy.BgvpSPpUAD(new Signal(Clock.Now, ComponentType.CrossExit, SignalType.Market, SignalSide.SellShort, instrument, text));
    }

    
    public virtual SingleOrder SellShort(Instrument instrument)
    {
      return this.SellShort(instrument,  this.Strategy.Name);
    }

    
    public virtual SingleOrder SellShort(Instrument instrument, FillOnBarMode mode, string text)
    {
      if (!this.Strategy.IsInstrumentActive(instrument))
        return (SingleOrder) null;
      return this.Strategy.BgvpSPpUAD(new Signal(Clock.Now, ComponentType.CrossExit, SignalType.Market, SignalSide.SellShort, instrument, text)
      {
        Fuwj5CvMiW = true,
        R2djQy947W = mode
      });
    }

    
    public virtual SingleOrder SellShort(Instrument instrument, FillOnBarMode mode)
    {
      return this.Sell(instrument, mode,  this.Strategy.Name);
    }
  }
}
