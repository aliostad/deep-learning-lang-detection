using Core.Common.Core;

namespace YourMdb.Client.Entities
{

    public partial class TrackArtistInstrument : ObjectBase
    {
        private int _trackArtistInstrumentId;
        private int _trackArtistId;
        private int _instrumentId;
        private Instrument _instrument;
        private TrackArtist _trackArtist;

        public int TrackArtistInstrumentId
        {
            get { return _trackArtistInstrumentId; }
            set
            {
                if (value == _trackArtistInstrumentId) return;
                _trackArtistInstrumentId = value;
                OnPropertyChanged();
            }
        }


        public int TrackArtistId
        {
            get { return _trackArtistId; }
            set
            {
                if (value == _trackArtistId) return;
                _trackArtistId = value;
                OnPropertyChanged();
            }
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


        public   Instrument Instrument
        {
            get { return _instrument; }
            set
            {
                if (Equals(value, _instrument)) return;
                _instrument = value;
                OnPropertyChanged();
            }
        }


        public   TrackArtist TrackArtist
        {
            get { return _trackArtist; }
            set
            {
                if (Equals(value, _trackArtist)) return;
                _trackArtist = value;
                OnPropertyChanged();
            }
        }

    }
}
