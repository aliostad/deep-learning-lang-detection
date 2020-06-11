using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CalcFarm.AnalyticUtil.Entity
{
    public enum AssetClass
    {
        EquityPx,
        Fx,
        Rates,
        ForwardFuture,
        Warrant
        // Additional asset classes ...
    }

    [Serializable]
    public abstract class Price
    {
        public long PublishId { get; set; }

        protected Instrument _Instrument = new Instrument();
        public Instrument Instrument
        {
            get { return _Instrument; }
            set { _Instrument = value; }
        }

        public string InstIdentifier
        {
            get { return Instrument.InstIdentifier; }
            set { Instrument.InstIdentifier = value; }
        }

        public AssetClass InstAssetClass
        {
            get { return Instrument.InstAssetClass; }
            set { Instrument.InstAssetClass = value; }
        }

        public string InstCcy
        {
            get { return Instrument.InstCcy; }
            set { Instrument.InstCcy = value; }
        }

        public override string ToString()
        {
            StringBuilder buffer = new StringBuilder();
            buffer.Append("PublishId: ").Append(PublishId)
                .Append(", Identifier: ").Append(InstIdentifier)
                .Append(", AssetClass: ").Append(InstAssetClass)
                .Append(", InstCcy: ").Append(InstCcy);
            return buffer.ToString();
        }
    }
}
