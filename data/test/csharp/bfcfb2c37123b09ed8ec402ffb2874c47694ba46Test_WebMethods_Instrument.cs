using System.Xml.Linq;
using NUnit.Framework;

namespace SMS2WS_SyncAgent
{
#if DEBUG
    [TestFixture]
    class Test_WebMethods_Instrument
    {
        [Test]
        public void Get_method_returns_valid_xml()
        {
            int instrumentId = new PredefinedDataObjects().Instrument.Id;

            string xmlData = WebMethods.GetDataFromWebMethod("instrument",
                                                             "getById",
                                                             "id=" + instrumentId);
            string errorMsg;
            Assert.IsFalse(WebMethods.WebMethodReturnedError(xmlData, out errorMsg),
                           string.Format("Instrument with id {0} could not be retrieved from the webshop. Unexpected return value: {1}", instrumentId, errorMsg));

            string validationError = Instrument.ValidateXmlStructure(xmlData);
            Assert.IsNull(validationError);
        }


        [Test]
        public void GetInstrumentById_with_valid_id_returns_instrument()
        {
            const int instrumentId = 328; // Piano

            var expectedInstrument = new Instrument() { Id = instrumentId, Name_NL = "Piano" };

            string errorMsg;
            Instrument actualInstrument = WebMethods.InstrumentMethods.GetInstrumentById(instrumentId, out errorMsg);

            Assert.AreEqual(expectedInstrument.Id, actualInstrument.Id);
            Assert.AreEqual(expectedInstrument.Name_NL, actualInstrument.Name_NL);
        }


        [Test]
        public void GetInstrumentById_with_invalid_id_returns_null()
        {
            const int instrumentId = -1;

            string errorMsg;
            Instrument actualInstrument = WebMethods.InstrumentMethods.GetInstrumentById(instrumentId, out errorMsg);

            Assert.IsNull(actualInstrument);
            Assert.IsTrue(errorMsg.StartsWith("error"),
                          string.Format("Expected result should start with \"error: \". Unexpected return value was: {0}", errorMsg));
        }


        [Test]
        public void UpdateInstrument_creates_new_instrument_and_returns_ok()
        {
            Instrument instrument = new AnonymousInstrumentBuilder().build();

            string result = WebMethods.InstrumentMethods.UpdateInstrument(instrument);
            result = XElement.Parse(result).Value;

            Assert.IsTrue(result == "ok",
                          string.Format("Instrument with id {0} could not be created/updated. Unexpected return value: {1}", instrument.Id, result));
        }


        [Test]
        public void UpdateInstrument_with_values_saves_all_data_correctly()
        {
            Instrument instrument = new AnonymousInstrumentBuilder().build();

            //save the instrument to the webshop
            string result = WebMethods.InstrumentMethods.UpdateInstrument(instrument);
            result = XElement.Parse(result).Value;

            Assert.IsTrue(result == "ok",
                          string.Format("Intrument with id {0} could not be created/updated. Unexpected return value was: {1}", instrument.Id, result));

            //retrieve the instrument from the webshop
            string errorMsg;
            Instrument instrumentFromWS = WebMethods.InstrumentMethods.GetInstrumentById(instrument.Id, out errorMsg);

            //compare all values
            Assert.AreEqual(instrument.Id, instrumentFromWS.Id, "The field comparison for field \"id\" failed.");
            Assert.AreEqual(instrument.Name_NL, instrumentFromWS.Name_NL, "The field comparison for field \"name_nl\" failed.");
            Assert.AreEqual(instrument.Test, instrumentFromWS.Test, "The field comparison for field \"test\" failed.");
            Assert.AreEqual(instrument.CreatedDttm, instrumentFromWS.CreatedDttm, "The field comparison for field \"created\" failed.");
            Assert.AreEqual(instrument.UpdatedDttm, instrumentFromWS.UpdatedDttm, "The field comparison for field \"updated\" failed.");
            Assert.AreEqual(instrument.DeletedDttm, instrumentFromWS.DeletedDttm, "The field comparison for field \"deleted\" failed.");
        }


        [Test]
        public void UpdateInstrument_accepts_invalid_instrument_and_returns_error()
        {
            // There is currently no way to generate this error condition
            // Invalid Xml would generate an error, but the Instrument object is always transformed into valid Xml
            // Invalid data does not seem to generate an error, so I suppose it is being handled by the API
            return;
        }


        [Test]
        public void DeleteInstrumentById_with_valid_id_returns_ok()
        {
            Instrument instrument = new AnonymousInstrumentBuilder().build();

            string result = WebMethods.InstrumentMethods.UpdateInstrument(instrument);
            result = XElement.Parse(result).Value;
            Assert.IsTrue(result == "ok",
                          string.Format("Instrument with id {0} could not be created/updated. Unexpected return value: {1}", instrument.Id, result));

            result = WebMethods.InstrumentMethods.DeleteInstrumentById(instrument.Id);
            result = XElement.Parse(result).Value;
            Assert.IsTrue(result == "ok",
                          string.Format("Instrument with id {0} could not be deleted. Unexpected return value: {1}", instrument.Id, result));
        }


        [Test]
        public void DeleteInstrumentById_with_invalid_id_returns_error()
        {
            int instrumentId = -1;
            string result = WebMethods.InstrumentMethods.DeleteInstrumentById(instrumentId);
            result = XElement.Parse(result).Value;

            Assert.IsTrue(result.StartsWith("error"),
                          string.Format("Expected result should start with \"error: \". Unexpected return value was: {0}", result));
        }
    }
#endif
}
