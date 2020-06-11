using System;
using System.Collections.Generic;

namespace LQT.Core.Domain
{
    /// <summary>
    /// ForecastCategoryInstrument object for NHibernate mapped table 'ForecastCategoryInstrument'.
    /// </summary>
    public class ForecastCategoryInstrument
    {
        #region Member Variables

        private int _id;
        private Instrument _instrument;
        private int _forecastId;
        private decimal _testRunPercentage;

        #endregion

        #region Constructors

        public ForecastCategoryInstrument() 
        {
            this._id = -1;
        }

        #endregion

        #region Public Properties

        public virtual int Id
        {
            get { return _id; }
            set { _id = value; }
        }

        public virtual Instrument Instrument
        {
            get { return _instrument; }
            set { _instrument = value; }
        }

        public virtual int ForecastId
        {
            get { return _forecastId; }
            set { _forecastId = value; }
        }

        public virtual decimal TestRunPercentage
        {
            get { return _testRunPercentage; }
            set { _testRunPercentage = value; }

        }

        #endregion

        
    }
}

