// ----------------------------------------------------+
// This file containing example of dynamic polymorphism 
// through method overriding.
// ----------------------------------------------------+

namespace PolymorphismClassLibrary.DynamicPolymorphism.MethodOverriding
{
    /// <summary>
    /// Class to play an instrument.
    /// </summary>
    public class PlayInstrument
    {
        /// <summary>
        /// Start playing an instrument.
        /// </summary>
        /// <param name="instrument">A general input parameter.</param>
        /// <returns>Instrument playing sound.</returns>
        public string StartPlaying(Instrument instrument)
        {
            return instrument.Play();
        }
    }
}
