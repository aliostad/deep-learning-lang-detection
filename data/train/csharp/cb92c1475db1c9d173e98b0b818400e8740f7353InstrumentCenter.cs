using FutureArbitrage.Contract;
using FutureArbitrage.Frame;
using FutureArbitrage.PL;
using FutureArbitrage.Util;
using System.Linq;

namespace FutureArbitrage.BLL
{
    public class InstrumentCenter : BindableBase
    {
        private const string INSTRUMENT_CONFIG_KEY = "INSTRUMENT_CONFIG_KEY";

        private InstrumentCenter() { }
        private static readonly InstrumentCenter instance = new InstrumentCenter();
        public static InstrumentCenter Instance { get { return instance; } }

        public void Init()
        {
            this.InstrumentIDs = ConfigHelper.GetConfig<string[]>(INSTRUMENT_CONFIG_KEY);
            if (this.InstrumentIDs == null)
            {
                this.InstrumentIDs = new string[0];
            }
        }

        private string[] instrumentIDs;
        public string[] InstrumentIDs
        {
            get
            {
                return this.instrumentIDs;
            }
            set
            {
                this.instrumentIDs = value;
                this.NotifyPropertyChanged("InstrumentIDs");
            }
        }

        public void SetInstruments(Instrument[] instrument)
        {
            this.InstrumentIDs = instrument.Select(p => p.InstrumentID).ToArray();
            ConfigHelper.SaveConfig(INSTRUMENT_CONFIG_KEY, this.InstrumentIDs);
        }
    }
}
