using DocumentFormat.OpenXml.Wordprocessing;
using MvvX.Plugins.OpenXMLSDK.Word;

namespace MvvX.Plugins.OpenXMLSDK.Platform.Word
{
    /// <summary>
    /// AltChunk element
    /// </summary>
    public class PlatformAltChunk : PlatformOpenXmlElement, IAltChunk
    {
        private readonly AltChunk altChunk;

        /// <summary>
        /// Constructor
        /// </summary>
        /// <param name="altChunk"></param>
        public PlatformAltChunk(AltChunk altChunk)
            : base(altChunk)
        {
            this.altChunk = altChunk;
        }
    }
}
