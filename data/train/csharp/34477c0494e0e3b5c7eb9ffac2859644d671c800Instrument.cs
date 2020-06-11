using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace ASPire_Training
{
    public class Instrument
    {
        //Fields
        private int instrumentID;
        private string instrumentName;
        private int weigth;
        private string type;

        //Properties
        #region properties

        public int InstrumentId
        {
            get { return instrumentID; }
            set { instrumentID = value; }
        }

        public string InstrumentName
        {
            get { return instrumentName; }
            set { instrumentName = value; }
        }

        public int Weigth
        {
            get { return weigth; }
            set { weigth = value; }
        }

        public string Type
        {
            get { return type; }
            set { type = value; }
        }
        #endregion

        //Constructor
        public Instrument(int instrumentID, string instrumentName, int weigth, string type)
        {
            this.instrumentID = instrumentID;
            this.instrumentName = instrumentName;
            this.weigth = weigth;
            this.type = type;
        }
    }
}