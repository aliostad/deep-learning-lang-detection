using System.Collections.Generic;

namespace QuickRep.WeatherV3
{
    // (Lidt) mere generel implementation af en vejstation. 
    // Ikke længere reference til specifik kategori af instrumenter.
    // Kun kendskab i form af et interface!

    public class WeatherStationV3
    {
        #region Instance fields

        private string _location;
        private List<IWeatherInstrument> _instruments;

        #endregion

        #region Constructor

        public WeatherStationV3(string location, List<IWeatherInstrument> instruments = null)
        {
            _location = location;
            _instruments = instruments ?? new List<IWeatherInstrument>();
        }

        #endregion

        #region Properties

        public string Location
        {
            get { return _location; }
        }

        #endregion

        #region Metoder

        public void Reset()
        {
            foreach (IWeatherInstrument instrument in _instruments)
            {
                instrument.Reset();
            }
        }

        public void AddInstrument(IWeatherInstrument instrument)
        {
            _instruments.Add(instrument);
        }

        // Bemærk at vi her definerer vores WeatherStationV3-specifikke
        // version af ToString (oprindeligt defineret i Object-klassen,
        // som alle klasser arver fra).

        public override string ToString()
        {
            string report = "Current weather at " + Location + "\n";
            report += "--------------------------------------\n";

            foreach (IWeatherInstrument instrument in _instruments)
            {
                report += instrument.CurrentValue + " " + instrument.UnitOfMeasurement + "\n";
            }

            return report;
        }

        #endregion
    }
}