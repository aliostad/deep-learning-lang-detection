using System.Collections.Generic;
using Core.Common.Core;

namespace YourMdb.Client.Entities
{

    public partial class Instrument : ObjectBase
    {
        private int _instrumentId;
        private string _name;

        public Instrument()
        {
            TrackArtistInstruments = new HashSet<TrackArtistInstrument>();
        }


        public int InstrumentId
        {
            get { return _instrumentId; }
            set
            {
                if (value == _instrumentId) return;
                _instrumentId = value;
                OnPropertyChanged();
            }
        }


        public string Name
        {
            get { return _name; }
            set
            {
                if (value == _name) return;
                _name = value;
                OnPropertyChanged();
            }
        }


        public   ICollection<TrackArtistInstrument> TrackArtistInstruments { get; set; }

  
    }
}
