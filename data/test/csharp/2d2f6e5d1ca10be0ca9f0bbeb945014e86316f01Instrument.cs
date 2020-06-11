using OpenQuant.API.Design;
using FreeQuant.FIX;
using System;
using System.ComponentModel;
using System.Drawing.Design;
using FreeQuant;

namespace OpenQuant.API
{
    ///<summary>
    ///  A financial instrument
    ///</summary>
    public class Instrument
    {
        private const string CATEGORY_APPEARANCE = "Appearance";
        private const string CATEGORY_APPEARANCE_ALTERNATIVE = "Appearance (alternative)";
        private const string CATEGORY_DERIVATIVE = "Derivative";
        private const string CATEGORY_MARGIN = "Margin";
        private const string CATEGORY_INDUSTRY = "Industry";
        private const string CATEGORY_DISPLAY = "Display";
        private const string CATEGORY_TICK_SIZE = "TickSize";
        internal FreeQuant.Instruments.Instrument instrument;
        private OrderBook book;

        [Description("Instrument symbol")]
        [Category("Appearance")]
        public string Symbol
        {
            get
            {
                return this.instrument.Symbol;
            }
        }

        [Description("Instrument Type (Stock, Futures, Option, Bond, ETF, Index, etc.)")]
        [Category("Appearance")]
        public InstrumentType Type
        {
            get
            {
                return EnumConverter.Convert(this.instrument.SecurityType);
            }
        }

        [Description("Instrument description")]
        [Category("Appearance")]
        public string Description
        {
            get
            {
                return this.instrument.SecurityDesc;
            }
            set
            {
                this.instrument.SecurityDesc = value;
                this.instrument.Save();
            }
        }

        [Category("Appearance")]
        [Description("Instrument exchange")]
        public string Exchange
        {
            get
            {
                return this.instrument.SecurityExchange;
            }
            set
            {
                this.instrument.SecurityExchange = value;
                this.instrument.Save();
            }
        }

        [Category("Appearance")]
        [Description("Instrument currency code (USD, EUR, RUR, CAD, etc.)")]
        public string Currency
        {
            get
            {
                return this.instrument.Currency;
            }
            set
            {
                this.instrument.Currency = value;
                this.instrument.Save();
            }
        }

        [Category("Appearance (alternative)")]
        [Editor(typeof(AltIDGroupListEditor), typeof(UITypeEditor))]
        [Description("Instrument alternative symbol")]
        [TypeConverter(typeof(AltIDGroupListTypeConverter))]
        [RefreshProperties(RefreshProperties.All)]
        public AltIDGroupList AltIDGroups { get; private set; }

        [Obsolete("Use Instrument.AltIDGroups property instead")]
        [Category("Appearance (alternative)")]
        [Description("Instrument alternative symbol")]
        [Browsable(false)]
        public string AltSymbol
        {
            get
            {
                if (this.instrument.SecurityAltIDGroup.Count == 0)
                    return string.Empty;
                else
                    return this.instrument.SecurityAltIDGroup[0].SecurityAltID;
            }
            set
            {
                if (this.instrument.SecurityAltIDGroup.Count == 0)
                    this.instrument.SecurityAltIDGroup.Add((FIXGroup)new FIXSecurityAltIDGroup());
                this.instrument.SecurityAltIDGroup[0].SecurityAltID = value;
                this.instrument.Save();
            }
        }

        [Browsable(false)]
        [Description("Alternative source of instrument definition (provider name)")]
        [Obsolete("Use Instrument.AltIDGroups property instead")]
        [Editor(typeof(AltSourceTypeEditor), typeof(UITypeEditor))]
        [Category("Appearance (alternative)")]
        public string AltSource
        {
            get
            {
                if (this.instrument.SecurityAltIDGroup.Count == 0)
                    return string.Empty;
                else
                    return this.instrument.SecurityAltIDGroup[0].SecurityAltIDSource;
            }
            set
            {
                if (this.instrument.SecurityAltIDGroup.Count == 0)
                    this.instrument.SecurityAltIDGroup.Add((FIXGroup)new FIXSecurityAltIDGroup());
                this.instrument.SecurityAltIDGroup[0].SecurityAltIDSource = value;
                this.instrument.Save();
            }
        }

        [Obsolete("Use Instrument.AltIDGroups property instead")]
        [Browsable(false)]
        [Category("Appearance (alternative)")]
        [Description("Instrument alternative exchange")]
        public string AltExchange
        {
            get
            {
                if (this.instrument.SecurityAltIDGroup.Count == 0)
                    return string.Empty;
                else
                    return this.instrument.SecurityAltIDGroup[0].SecurityAltExchange;
            }
            set
            {
                if (this.instrument.SecurityAltIDGroup.Count == 0)
                    this.instrument.SecurityAltIDGroup.Add((FIXGroup)new FIXSecurityAltIDGroup());
                this.instrument.SecurityAltIDGroup[0].SecurityAltExchange = value;
                this.instrument.Save();
            }
        }

        [Description("Contract Value Factor by which price must be adjusted to determine the true nominal value of one futures/options contract. (Qty * Price) * Factor = Nominal Value")]
        [Category("Derivative")]
        [DefaultValue(0.0)]
        public double Factor
        {
            get
            {
                return this.instrument.Factor;
            }
            set
            {
                this.instrument.Factor = value;
                this.instrument.Save();
            }
        }

        [Description("Instrument maturity")]
        [Category("Derivative")]
        public DateTime Maturity
        {
            get
            {
                return this.instrument.MaturityDate;
            }
            set
            {
                this.instrument.MaturityDate = value;
                this.instrument.Save();
            }
        }

        [Description("Instrument strike price")]
        [Category("Derivative")]
        [DefaultValue(0.0)]
        public double Strike
        {
            get
            {
                return this.instrument.StrikePrice;
            }
            set
            {
                this.instrument.StrikePrice = value;
                this.instrument.Save();
            }
        }

        [Category("Derivative")]
        [Description("Option type : put or call")]
        public PutCall PutCall
        {
            get
            {
                switch (this.instrument.PutOrCall)
                {
                    case PutOrCall.Put:
                        return PutCall.Put;
                    case PutOrCall.Call:
                        return PutCall.Call;
                    default:
                        throw new ArgumentException(string.Format("PutCall is not supported - {0}", (object)this.instrument.PutOrCall));
                }
            }
            set
            {
                switch (value)
                {
                    case PutCall.Put:
                        this.instrument.PutOrCall = PutOrCall.Put;
                        break;
                    case PutCall.Call:
                        this.instrument.PutOrCall = PutOrCall.Call;
                        break;
                    default:
                        throw new ArgumentException(string.Format("PutCall is not supported - {0}", (object)value));
                }
                this.instrument.Save();
            }
        }

        [Category("Margin")]
        [DefaultValue(0.0)]
        [Description("Initial margin (simulations)")]
        public double Margin
        {
            get
            {
                return this.instrument.Margin;
            }
            set
            {
                this.instrument.Margin = value;
                this.instrument.Save();
            }
        }

        [Category("Industry")]
        [Description("Industry group")]
        public string Group
        {
            get
            {
                return this.instrument.IndustryGroup;
            }
            set
            {
                this.instrument.IndustryGroup = value;
                this.instrument.Save();
            }
        }

        [Category("Industry")]
        [Description("Industry sector")]
        public string Sector
        {
            get
            {
                return this.instrument.IndustrySector;
            }
            set
            {
                this.instrument.IndustrySector = value;
                this.instrument.Save();
            }
        }

        [Description("C# price format string (example: F4 - show four decimal numbers for Forex contracts)")]
        [DefaultValue("F2")]
        [Category("Display")]
        public string PriceFormat
        {
            get
            {
                return this.instrument.PriceDisplay;
            }
            set
            {
                this.instrument.PriceDisplay = value;
                this.instrument.Save();
            }
        }

        [Category("TickSize")]
        [DefaultValue(0.0)]
        public double TickSize
        {
            get
            {
                return this.instrument.TickSize;
            }
            set
            {
                this.instrument.TickSize = value;
                this.instrument.Save();
            }
        }

        [Browsable(false)]
        public Bar Bar
        {
            get
            {
                return new Bar(this.instrument.Bar);
            }
        }

        [Browsable(false)]
        public Trade Trade
        {
            get
            {
                return new Trade(this.instrument.Trade);
            }
        }

        [Browsable(false)]
        public Quote Quote
        {
            get
            {
                return new Quote(this.instrument.Quote);
            }
        }

        [Browsable(false)]
        public OrderBook OrderBook
        {
            get
            {
                return this.book;
            }
        }

        internal Instrument(FreeQuant.Instruments.Instrument instrument)
        {
            this.instrument = instrument;
            this.book = new OrderBook(instrument.OrderBook);
            this.AltIDGroups = new AltIDGroupList(this);
        }

        public Instrument(InstrumentType type, string symbol)
            : this(type, symbol, Framework.Configuration.DefaultExchange, Framework.Configuration.DefaultCurrency)
        {
        }

        public Instrument(InstrumentType type, string symbol, string secutityExchange, string currency)
        {
            if (FreeQuant.Instruments.InstrumentManager.Instruments.Contains(symbol))
                return;
            this.instrument = new FreeQuant.Instruments.Instrument(symbol, EnumConverter.Convert(type));
            this.instrument.SecurityExchange = secutityExchange;
            this.instrument.Currency = currency;
            this.instrument.Save();
        }

        public override string ToString()
        {
            return this.instrument.ToString();
        }

        public string GetSymbol(string source)
        {
            return this.instrument.GetSymbol(source);
        }

        public string GetExchange(string source)
        {
            return this.instrument.GetSecurityExchange(source);
        }
    }
}
