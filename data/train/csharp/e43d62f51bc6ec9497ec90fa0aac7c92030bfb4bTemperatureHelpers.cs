using Prover.CommProtocol.Common.Items;
using Prover.Core.Models.Instruments;

namespace Prover.Core.Extensions
{
    public static class TemperatureItems
    {
        private const int GAS_TEMP = 26;
        private const int TEMP_FACTOR = 45;
        private const int TEMP_UNITS = 89;
        private const int BASE_TEMP = 34;

        public static string Range(this Instrument instrument)
        {
            return "-40 - 150 " + instrument.TemperatureUnits();
        }

        public static string TemperatureUnits(this Instrument instrument)
        {
            return instrument.Items.GetItem(TEMP_UNITS).Description;
        }

        public static decimal? EvcBaseTemperature(this Instrument instrument)
        {
            return instrument.Items.GetItem(BASE_TEMP).NumericValue;
        }
    }
}