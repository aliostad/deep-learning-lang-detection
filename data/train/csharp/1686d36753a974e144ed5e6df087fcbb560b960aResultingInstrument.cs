using System;
using System.Collections .Generic ;

namespace BRE.Lib.TermStructures
{
    using UV.Lib.Products;

    public class ResultingInstrument : IEquatable<ResultingInstrument>
    {

        #region Members
        // *****************************************************************
        // ****                     Members                             ****
        // *****************************************************************
        //        
        public string ResultingInstrumentNameTT;
        public string ResultingInstrumentNameDataBase;
        public bool IsRealInstrumentOnMarket;
        public InstrumentName ResultingInstrumentName;
        #endregion// members


        #region Constructors
        // *****************************************************************
        // ****                     Constructors                        ****
        // *****************************************************************
        //
        //
        //       
        public ResultingInstrument()
        {

        }
        #endregion//Constructors


        #region Properties
        // *****************************************************************
        // ****                     Properties                          ****
        // *****************************************************************
        //
        //
        /// <summary>
        /// The instrument data base name and the tt name should not be null or empty in normal case.
        /// They are read from the database and should be valid names.
        /// </summary>
        /// <returns></returns>
        public bool IsEmpty
        {
            get
            {
                return string.IsNullOrEmpty(ResultingInstrumentNameDataBase) || string.IsNullOrEmpty(ResultingInstrumentNameTT);
            }
        }
        #endregion//Properties


        #region no Public Methods
        // *****************************************************************
        // ****                     Public Methods                      ****
        // *****************************************************************
        //
        //
        //
        //
        //
        //
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


        #region Public Override Methods
        // *****************************************************************
        // ****             Public Override Methods                     ****
        // *****************************************************************
        //
        //
        //
        //
        // ****             ToString()              ****
        //
        public override string ToString()
        {
            return ResultingInstrumentNameTT;
        }//ToString()
        //
        //
        //
        //
        // ****                 Equals                  ****
        //
        public override bool Equals(object obj)
        {
            if (obj is ResultingInstrument)
            {
                ResultingInstrument other = (ResultingInstrument)obj;
                return this.Equals(other);
            }
            else
                return false;
        }
        public bool Equals(ResultingInstrument other)
        {
            bool isEqual = this.ResultingInstrumentNameTT.Equals(other.ResultingInstrumentNameTT) &&
                    this.ResultingInstrumentNameDataBase.Equals(other.ResultingInstrumentNameDataBase) &&
                    this.ResultingInstrumentName.Equals(other.ResultingInstrumentName);
            return isEqual;
        }
        public static bool operator ==(ResultingInstrument a, ResultingInstrument b)
        {
            if ((object)a == null)
                return false;
            return a.Equals(b);
        }
        public static bool operator !=(ResultingInstrument a, ResultingInstrument b)
        {
            return !(a == b);
        }
        public override int GetHashCode()
        {
            return this.ResultingInstrumentNameTT.GetHashCode();
        }
        #endregion//Public Methods

    }
}
