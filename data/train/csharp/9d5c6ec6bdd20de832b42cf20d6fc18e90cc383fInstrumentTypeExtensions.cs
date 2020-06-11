namespace MidiGremlin
{
	/// <summary>
	/// This class contains extension methods for the <see cref="InstrumentType"/> enum.
	/// </summary>
	public static class InstrumentTypeExtensions
	{
		/// <summary>
		/// Is this <see cref="InstrumentType"/> a drum instrument? Drum instruments are played on their own channel.
		/// </summary>
		/// <returns>Whether this InstrumentType is a drum.</returns>
		public static bool IsDrum(this InstrumentType instrumentType)
		{
			return ((int)instrumentType & 0x7fffff80) == 0x100;
		}
	}
}