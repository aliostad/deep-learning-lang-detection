using SmartQuant;

namespace SmartQuant.FIXApplication
{
	public static class FIXTypeConverter
	{
		public static class SecurityType
		{
			public static string Convert (InstrumentType? value)
			{
				if (!value.HasValue)
					return (string)null;
				switch (value.Value) {
				case InstrumentType.Stock:
					return "CS";
				case InstrumentType.Future:
					return "FUT";
				case InstrumentType.Option:
					return "OPT";
				case InstrumentType.FutureOption:
					return "FOP";
				case InstrumentType.Bond:
					return "BOND";
				case InstrumentType.FX:
					return "FOR";
				case InstrumentType.Index:
					return "IDX";
				case InstrumentType.ETF:
					return "ETF";
				case InstrumentType.MultiLeg:
					return "MLEG";
				default:
					return (string)null;
				}
			}

			public static InstrumentType? Convert (string value)
			{
				if (value == null)
					return new InstrumentType? ();
				switch (value) {
				case "CS":
					return new InstrumentType? (InstrumentType.Stock);
				case "FUT":
					return new InstrumentType? (InstrumentType.Future);
				case "OPT":
					return new InstrumentType? (InstrumentType.Option);
				case "FOP":
					return new InstrumentType? (InstrumentType.FutureOption);
				case "IDX":
					return new InstrumentType? (InstrumentType.Index);
				case "FOR":
					return new InstrumentType? (InstrumentType.FX);
				case "ETF":
					return new InstrumentType? (InstrumentType.ETF);
				case "MLEG":
					return new InstrumentType? (InstrumentType.MultiLeg);
				case "BOND":
					return new InstrumentType? (InstrumentType.Bond);
				default:
					return new InstrumentType? ();
				}
			}
		}

		public static class PutOrCall
		{
			public static int? Convert (PutCall? value)
			{
				if (!value.HasValue)
					return new int? ();
				switch (value.Value) {
				case PutCall.Put:
					return new int? (0);
				case PutCall.Call:
					return new int? (1);
				default:
					return new int? ();
				}
			}

			public static PutCall? Convert (int? value)
			{
				if (!value.HasValue)
					return new PutCall? ();
				switch (value.Value) {
				case 0:
					return new PutCall? (PutCall.Put);
				case 1:
					return new PutCall? (PutCall.Call);
				default:
					return new PutCall? ();
				}
			}
		}
	}
}
