using Deedle;
using System;
using System.ComponentModel;


namespace VARCalculator.Model
{
    public struct InstrumentModel
    {
        public string instrumentID { get; set; }
        public Series<DateTime, double> instrumentReturns { get; set; }
        public double portfolioWeight { get; set; }
        public double mean { get; set; }
        public double volatility { get; set; }
        public double VAR { get; set; }
        public double[] instrumentReturnsArray { get; set; }

        //public InstrumentModel(string instrumentID)
        //{
        //    this.instrumentID = instrumentID;
        //}

        //public InstrumentModel(string instrumentID, double portfolioWeight)
        //{
        //    this.instrumentID = instrumentID;
        //    this.portfolioWeight = portfolioWeight;
        //}

    }
}
