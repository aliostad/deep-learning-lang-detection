using System;
using System.Collections.Generic;

namespace BRE.Lib.TermStructures
{
    using UV.Lib.Products;

    public class HedgeOption
    {

        #region Members
        // *****************************************************************
        // ****                     Members                             ****
        // *****************************************************************
        //   
        public Dictionary<InstrumentName, int> InstrumentToWeights;
        public InstrumentName QuoteInstrument;
        public int QuoteWeight;
        public List<InstrumentName> HedgeInstruments;
        public ResultingInstrument ResultingInstrument;
        public int ResultingWeight;
        #endregion// members


        #region Constructors
        // *****************************************************************
        // ****                     Constructors                        ****
        // *****************************************************************
        //
        //
        //  
        public HedgeOption()
        {
            InstrumentToWeights = new Dictionary<InstrumentName, int>();
            HedgeInstruments = new List<InstrumentName>();
        }
        #endregion//Constructors


        #region Properties
        // *****************************************************************
        // ****                     Properties                          ****
        // *****************************************************************
        //
        //
        #endregion//Properties


        #region Public Methods
        // *****************************************************************
        // ****                     Public Methods                      ****
        // *****************************************************************
        //
        //
        //
        //
        //
        //
        /// <summary>
        /// Add the instrument and its weight to the dictionary for later use.
        /// </summary>
        /// <param name="instrument"></param>
        /// <param name="weight"></param>
        /// <returns></returns>
        public bool TryAddInstrumentAndWeight(InstrumentName instrument, int weight)
        {
            bool isSuccess = false;
            if (!InstrumentToWeights.ContainsKey(instrument))
            {
                InstrumentToWeights.Add(instrument, weight);
                if (!HedgeInstruments.Contains(instrument) && QuoteInstrument != null && instrument != QuoteInstrument)
                {
                    HedgeInstruments.Add(instrument);
                    isSuccess = true;
                }
            }
            return isSuccess;
        }
        #endregion//Public Methods


        #region no Private Methods
        // *****************************************************************
        // ****                     Private Methods                     ****
        // *****************************************************************
        //
        //
        #endregion//Private Methods


        #region no Event Handlers
        // *****************************************************************
        // ****                     Event Handlers                     ****
        // *****************************************************************
        //
        //
        #endregion//Event Handlers

    }
}
