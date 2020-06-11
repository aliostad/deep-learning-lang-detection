using FreeQuant.FIX;
using FreeQuant.Instruments;
using System;

namespace FreeQuant.Pricers
{
  public class IndexPricer : IPricer
  {
    public virtual double Price(Instrument instrument)
    {
      double num = 0.0;
      foreach (Leg leg in (FIXGroupList) instrument.Legs)
      {
        switch (leg.LegSide)
        {
          case '1':
          case '3':
            num += leg.LegRatioQty * leg.Instrument.Price();
            continue;
          case '2':
          case '5':
            num -= leg.LegRatioQty * leg.Instrument.Price();
            continue;
          default:
            throw new ApplicationException( (object) instrument.Symbol + (string) (object) leg.LegSide + leg.Instrument.Symbol);
        }
      }
      return num;
    }

    public virtual double Volatility(Instrument instrument)
    {
      return 0.0;
    }

    public virtual double Delta(Instrument instrument)
    {
      return 0.0;
    }

    public virtual double Gamma(Instrument instrument)
    {
      return 0.0;
    }

    public virtual double Theta(Instrument instrument)
    {
      return 0.0;
    }

    public virtual double Vega(Instrument instrument)
    {
      return 0.0;
    }

    
    public virtual double Rho(Instrument instrument)
    {
      return 0.0;
    }

    public virtual double Price(Instrument instrument, DateTime dateTime)
    {
      double num = 0.0;
      foreach (Leg leg in (FIXGroupList) instrument.Legs)
      {
        switch (leg.LegSide)
        {
          case '1':
          case '3':
            num += leg.LegRatioQty * leg.Instrument.Price(dateTime);
            continue;
          case '2':
          case '5':
            num -= leg.LegRatioQty * leg.Instrument.Price();
            continue;
          default:
            throw new ApplicationException((object) instrument.Symbol + (string) (object) leg.LegSide  + leg.Instrument.Symbol);
        }
      }
      return num;
    }

    
    public virtual double Volatility(Instrument instrument, DateTime dateTime1, DateTime dateTime2)
    {
      return 0.0;
    }

    
    public virtual double Delta(Instrument instrument, DateTime dateTime)
    {
      return 0.0;
    }

    
    public virtual double Gamma(Instrument instrument, DateTime dateTime)
    {
      return 0.0;
    }

    
    public virtual double Theta(Instrument instrument, DateTime dateTime)
    {
      return 0.0;
    }

    
    public virtual double Vega(Instrument instrument, DateTime dateTime)
    {
      return 0.0;
    }

    public virtual double Rho(Instrument instrument, DateTime dateTime)
    {
      return 0.0;
    }
  }
}
