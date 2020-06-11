using System;
using System.Globalization;

namespace IW.Model
{
    public class InstrumentMarketData
    {
        private static readonly Random _random = new Random();

        public string InstrumentId { get; set; }
        public string Description { get; set; }

        public InstrumentMarketData(string id)
        {
            InstrumentId = string.Format("Id - {0}", id);
            Description = string.Format("Desc - {0}", id);
        }

        public InstrumentMarketData()
        { }

        public static InstrumentMarketData New
        {
            get
            {
                var id = _random.Next(1000).ToString(CultureInfo.InvariantCulture);
                return new InstrumentMarketData(id);
            }
        }
    }
}
