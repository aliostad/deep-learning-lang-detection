using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

using Fin.Business.Common.Model;

namespace Fin.Data.Model
{
    public class Value: IValue
    {
        public int Id { get; set; }

        public int InstrumentId { get; set; }

        private IInstrument _instrument;

        [ForeignKey("InstrumentId")]
        public Instrument Instrument
        {
            get { return (Instrument)_instrument; }
            set { _instrument = (Instrument)value; }
        }
        IInstrument IValue.Instrument {
            get { return _instrument; }
            set { _instrument = value; }
        }

        public DateTime Date { get; set; }

        public decimal Amount { get; set; }
    
        [Timestamp]
        public byte[] RowVersion { get; set; }
    }
}
