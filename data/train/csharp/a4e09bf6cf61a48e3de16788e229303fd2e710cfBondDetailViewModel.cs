using System;
using RiskAnalysisTool.Instruments;

namespace RiskAnalysisTool.MobileApp.ViewModels
{
    internal class BondDetailViewModel : InstrumentDetailViewModel<Bond>
    {
        private DateTime _maturity;
        private double _price;

        public DateTime Maturity
        {
            get { return _maturity; }
            set { SetProperty(ref _maturity, value); }
        }

        public double Price
        {
            get { return _price; }
            set { SetProperty(ref _price, value); }
        }

        public override void LoadModel(Bond instrument)
        {
            base.LoadModel(instrument);
            Maturity = instrument.MaturityDate.Date;
            Price = instrument.Price;
        }

        public override void UpdateModel(Bond instrument)
        {
            base.UpdateModel(instrument);
            instrument.MaturityDate = Maturity.Date;
            instrument.Price = Price;
        }
    }
}