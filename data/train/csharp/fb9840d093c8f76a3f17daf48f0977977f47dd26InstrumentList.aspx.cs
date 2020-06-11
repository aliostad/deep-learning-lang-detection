using GuitarStore.Models;
using System;
using System.Collections.Generic;
using System.Web.ModelBinding;

namespace GuitarStore
{
    public partial class InstrumentList : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        public List<Instrument> GetInstruments([QueryString("id")] int? instrumentTypeId)
        {
            List<Instrument> instruments = new List<Instrument>();
            foreach(var item in Data.Instruments)
            {
                if(item.InstrumentTypeID == instrumentTypeId || instrumentTypeId == null) instruments.Add(item);
            }
            return instruments;
        }
    }
}