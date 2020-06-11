using System;
using System.Collections.Generic;

namespace LQT.Core.Domain
{
    /// <summary>
    /// SiteInstrument object for NHibernate mapped table 'SiteInstrument'.
    /// </summary>
    public class SiteInstrument
    {
        #region Member Variables

        private int _id;
        private Instrument _instrument;
        private ForlabSite _site;
        private int _quantity;
        private decimal _testRunPercentage;

        #endregion

        #region Constructors

        public SiteInstrument() 
        {
            this._id = -1;
        }

        #endregion

        #region Public Properties

        public int Id
        {
            get { return _id; }
            set { _id = value; }
        }

        public Instrument Instrument
        {
            get { return _instrument; }
            set { _instrument = value; }
        }

        public ForlabSite Site
        {
            get { return _site; }
            set { _site = value; }
        }

        public int Quantity
        {
            get { return _quantity; }
            set { _quantity = value; }
        }

        public decimal TestRunPercentage
        {
            get { return _testRunPercentage; }
            set { _testRunPercentage = value; }

        }

        #endregion

        
    }
}

