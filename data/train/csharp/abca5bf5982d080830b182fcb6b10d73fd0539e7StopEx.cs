using SmartQuant;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace QuantBox.Demo.Extension
{
    public enum StopIndicator
    {
        Price,
        Value,
    }

    /// <summary>
    /// 支持按价格止损和按价值止损
    /// </summary>
    public class StopEx : Stop
    {
        StopIndicator indicator;
        double _trailPrice;
        double _trailValue;

        public StopEx(SmartQuant.Strategy strategy, SmartQuant.Position position, DateTime time)
            : base(strategy, position, time)
        {
        }

        public StopEx(SmartQuant.Strategy strategy, SmartQuant.Position position, double level, StopType type, StopMode mode, StopIndicator stopIndicator)
            :base(strategy, position, level, type, mode)
        {
            this.indicator = stopIndicator;
        }

        //protected override double GetInstrumentPrice()
        //{
        //    if (this.indicator == StopIndicator.Price)
        //    {
        //        return base.GetInstrumentPrice();
        //    }

        //    double instrumentValue = 0.0;
            
        //    if (this.position.Side == SmartQuant.PositionSide.Long)
        //    {
        //        Bid bid = this.strategy.DataManager.GetBid(this.instrument);

        //        if (bid != null)
        //        {
        //            if (this.instrument.Legs.Count == 0)
        //            {
        //                this.instrument.Factor = (this.instrument.Factor == 0.0 ? 1.0 : this.instrument.Factor);
        //                instrumentValue += bid.Price * this.instrument.Factor * this.position.Qty;
        //            }
        //            else
        //            {
        //                foreach (Leg leg in this.instrument.Legs)
        //                {
        //                    leg.Instrument.Factor = leg.Instrument.Factor == 0.0 ? 1.0 : leg.Instrument.Factor;
        //                    instrumentValue += leg.Instrument.Bid.Price * leg.Weight * leg.Instrument.Factor * this.position.Qty;
        //                }
        //            }

        //            return this.GetPrice(instrumentValue);
        //        }
        //    }

        //    if (this.position.Side == SmartQuant.PositionSide.Short)
        //    {
        //        Ask ask = this.strategy.DataManager.GetAsk(this.instrument);

        //        if (ask != null)
        //        {
        //            if (this.instrument.Legs.Count == 0)
        //            {
        //                this.instrument.Factor = (this.instrument.Factor == 0.0 ? 1.0 : this.instrument.Factor);
        //                instrumentValue += ask.Price * this.instrument.Factor * this.position.Qty;
        //            }
        //            else
        //            {
        //                foreach (Leg leg in this.instrument.Legs)
        //                {
        //                    leg.Instrument.Factor = leg.Instrument.Factor == 0.0 ? 1.0 : leg.Instrument.Factor;
        //                    instrumentValue += leg.Instrument.Ask.Price * leg.Weight * leg.Instrument.Factor * this.position.Qty;
        //                }
        //            }

        //            return this.GetPrice(instrumentValue);
        //        }
        //    }

        //    Trade trade = this.strategy.DataManager.GetTrade(this.instrument);
        //    if (trade != null)
        //    {
        //        if (this.instrument.Legs.Count == 0)
        //        {
        //            this.instrument.Factor = (this.instrument.Factor == 0.0 ? 1.0 : this.instrument.Factor);
        //            instrumentValue += trade.Price * this.instrument.Factor * this.position.Qty;
        //        }
        //        else
        //        {
        //            foreach (Leg leg in this.instrument.Legs)
        //            {
        //                leg.Instrument.Factor = leg.Instrument.Factor == 0.0 ? 1.0 : leg.Instrument.Factor;
        //                instrumentValue += leg.Instrument.Trade.Price * leg.Weight * leg.Instrument.Factor * this.position.Qty;
        //            }
        //        }
        //        return this.GetPrice(instrumentValue);
        //    }

        //    Bar bar = this.strategy.DataManager.GetBar(this.instrument);
        //    if (bar != null)
        //    {
        //        if (this.instrument.Legs.Count == 0)
        //        {
        //            this.instrument.Factor = (this.instrument.Factor == 0.0 ? 1.0 : this.instrument.Factor);
        //            instrumentValue += bar.Close * this.instrument.Factor * this.position.Qty;
        //        }
        //        else
        //        {
        //            foreach (Leg leg in this.instrument.Legs)
        //            {
        //                leg.Instrument.Factor = leg.Instrument.Factor == 0.0 ? 1.0 : leg.Instrument.Factor;
        //                instrumentValue += leg.Instrument.Bar.Close * leg.Weight * leg.Instrument.Factor * this.position.Qty;
        //            }
        //        }

        //        return this.GetPrice(instrumentValue);
        //    }

        //    return this.GetPrice(instrumentValue);
        //}

        protected override double GetPrice(double price)
        {
            if (this.indicator == StopIndicator.Price)
            {
                return base.GetPrice(price);
            }

            // 这个地方有问题没解决
            double  factor = (instrument.Factor == 0.0 ? 1.0 : instrument.Factor);
            // 如果有多个Stop，一部分被平，这个价值发生变化
            return price * factor * position.Qty;
        }

        public double TrailPrice
        {
            get {
                if (this.indicator == StopIndicator.Price)
                {
                    return trailPrice;
                }
                // 这个地方有问题没解决
                double factor = (instrument.Factor == 0.0 ? 1.0 : instrument.Factor);
                // 如果有多个Stop，一部分被平，这个价值发生变化
                return trailPrice / factor / position.Qty;
            }
        }

        //public double TrailPrice
        //{
        //    get { return trailPrice; }
        //}

        public StopIndicator Indicator
        {
            get { return this.indicator; }
        }
    }
}
