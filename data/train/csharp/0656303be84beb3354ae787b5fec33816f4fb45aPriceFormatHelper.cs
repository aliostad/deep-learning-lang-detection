using FreeQuant.Instruments;

namespace OpenQuant.Shared
{
	public static class PriceFormatHelper
	{
		public static string GetFormat(Instrument instrument)
		{
			return instrument.PriceDisplay;
		}

		public static int GetDecimalPlaces(Instrument instrument)
		{
			string s = string.Empty;
			foreach (char c in PriceFormatHelper.GetFormat(instrument))
			{
				if (char.IsDigit(c))
					s = s + (object)c;
			}
			int result;
			if (!int.TryParse(s, out result))
				return 2;
			else
				return result;
		}
	}
}
