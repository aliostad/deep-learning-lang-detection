using System.Collections.Generic;

namespace CantAffordToRock.CoreGame
{
    public class Deck
    {
        private readonly List<Rocker> _rockers;

        public Instrument Instrument { get; }

        public Deck(Instrument instrument, List<Rocker> rockers)
        {
            Instrument = instrument;
            _rockers = rockers;
        }

        public Rocker Draw()
        {
            var rocker = _rockers[0];
            _rockers.RemoveAt(0);
            return rocker;
        }

        public void PutOnBottom(Rocker rocker)
        {
            _rockers.Add(rocker);
        }
    }
}
