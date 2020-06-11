using System;

namespace Redzen.Midi
{
    /// <summary>
    /// Extension methods for the Instrument enum.
    /// </summary>
    public static class InstrumentExtensions
    {
        #region Public Static Methods

        /// <summary>
        /// Returns true if the specified instrument is valid.
        /// </summary>
        /// <param name="instrument">The instrument to test.</param>
        public static bool IsValid(this Instrument instrument)
        {
            return (int)instrument >= 0 && (int)instrument < 128;
        }

        /// <summary>
        /// Throws an exception if instrument is not valid.
        /// </summary>
        /// <param name="instrument">The instrument to validate.</param>
        /// <exception cref="ArgumentOutOfRangeException">The instrument is out-of-range.
        /// </exception>
        public static void Validate(this Instrument instrument)
        {
            if(!instrument.IsValid()) {
                throw new ArgumentOutOfRangeException("Instrument out of range");
            }
        }

        #endregion
    }
}
