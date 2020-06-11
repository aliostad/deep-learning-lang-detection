using System;

using InstrumentType = BeatsByDre.DrumBeat.InstrumentType;

namespace BeatsByDre
{
    class InstrumentCan
    {
        // TODO: Maya Model
        // private Model _model;
        private InstrumentType _instrument;

        public InstrumentType Instrument
        {
            get { return _instrument; }
            set
            {
                _instrument = value;
                SetModelFromInstrument(_instrument);
            }
        }

        public InstrumentCan()
        {
            Clear();
        }

        public void Preview()
        {
            if (HasInstrument())
            {
                DrumMachine.GetInstance().Play(Instrument, 500, 100);
            }
        }

        public bool HasInstrument()
        {
            return !Instrument.Equals(InstrumentType.None);
        }

        public void Clear()
        {
            Instrument = InstrumentType.None;
        }

        // TODO: Implement
        private void SetModelFromInstrument(InstrumentType instrument)
        {
            // Set model in can according to instrument assigned
            switch (instrument)
            {
                case InstrumentType.None:
                    break;
                case InstrumentType.BassDrum:
                    break;
                case InstrumentType.SnareDrum:
                    break;
                case InstrumentType.TomDrum:
                    break;
                case InstrumentType.CrashCymbal:
                    break;
                case InstrumentType.HiHatCymbal:
                    break;
                case InstrumentType.Cowbell:
                    break;
                default:
                    throw new InvalidOperationException("Invalid beat type: " + instrument);
            }
        }
    }
}
