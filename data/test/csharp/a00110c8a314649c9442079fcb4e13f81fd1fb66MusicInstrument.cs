using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MusicalTracker.DAL.Interfaces;

namespace MusicalTracker.DAL.Concretes
{
    public class MusicInstrument : IMusicInstrument
    {
        private MusicInstrumentSalesForce _sfInstrumentData;
        private Borrower _Borrower;

        public MusicInstrument(MusicInstrumentSalesForce instrument, MusicInstrumentBorrowerSalesForce borrower)
        {
            _sfInstrumentData = instrument;
            _Borrower =  new Borrower(borrower);
        }
        public string Description
        {
            get
            {
                return _sfInstrumentData.DESCRIPTION__C;
            }
        }
        public string Name
        {
            get
            {
                return _sfInstrumentData.NAME;
            }
        }
        public InstrumentType Type
        {
            get
            {
                return Converters.ConvertInstrTypeStrToEnum(_sfInstrumentData.TYPE__C);
            }
        }
        public IBorrower Borrower
        {
            get
            {
                return _Borrower;
            }
        }
    }
}
