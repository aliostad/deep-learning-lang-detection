using System.Xml.Linq;

namespace SMS2WS_SyncAgent
{
    internal static partial class WebMethods
    {
        internal static class InstrumentMethods
        {
            /// <summary>
            /// Get an instrument from the Webshop
            /// </summary>
            /// <param name="instrumentId">Id of the instrument to be retrieved</param>
            /// <param name="errorMsg" type="output">Error message returned by the web method</param>
            /// <returns>Returns an Instrument object populated with data</returns>
            internal static Instrument GetInstrumentById(int instrumentId, out string errorMsg)
            {
                string xmlData = GetDataFromWebMethod("instrument",
                                                      "getById",
                                                      "id=" + instrumentId);
                if (WebMethodReturnedError(xmlData, out errorMsg))
                {
                    return null;
                }
                else
                {
                    errorMsg = null;
                    Instrument instrument = InstrumentRepository.LoadInstrumentFromXml(xmlData);
                    return instrument;
                }
            }

            /// <summary>
            /// Update an instrument in the webshop
            /// </summary>
            /// <param name="instrument">The instrument to be updated</param>
            /// <returns>Returns a string with "ok" or an error message</returns>
            internal static string UpdateInstrument(Instrument instrument)
            {
                string data = instrument.ToXml();
                string result = SendDataThroughWebMethod("instrument",
                                                         "update",
                                                         null,
                                                         data);
                XElement xml = XElement.Parse(result);
                return xml.ToString();
            }

            /// <summary>
            /// Delete an instrument from the webshop
            /// </summary>
            /// <param name="instrumentId">Id of the instrument to be deleted</param>
            /// <returns>Returns a string with "ok" or an error message</returns>
            internal static string DeleteInstrumentById(int instrumentId)
            {
                string result = GetDataFromWebMethod("instrument",
                                                     "deleteById",
                                                     "id=" + instrumentId);
                //TODO: check xmlData here

                XElement xml = XElement.Parse(result);
                return xml.ToString();
            }

        }
    }
}
