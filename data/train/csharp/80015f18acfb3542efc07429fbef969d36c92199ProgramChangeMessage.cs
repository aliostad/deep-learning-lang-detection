
namespace Redzen.Midi.Messages
{
    /// <summary>
    /// Program Change message.
    /// </summary>
    public class ProgramChangeMessage : ChannelMessage
    {
        readonly Instrument _instrument;

        #region Constructor

        /// <summary>
        /// Constructs a Program Change message.
        /// </summary>
        /// <param name="channel">MIDI channel.</param>
        /// <param name="instrument">Midi instrument.</param>
        public ProgramChangeMessage(Channel channel, Instrument instrument)
            : base(channel)
        {
            instrument.Validate();
            _instrument = instrument;
        }

        #endregion

        #region Properties

        /// <summary>
        /// MIDI instrument.
        /// </summary>
        public Instrument Instrument { get { return _instrument; } }

        #endregion
    }
}
