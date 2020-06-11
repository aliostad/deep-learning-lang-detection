using System;
using System.Xml.Linq;
using Bso.Archive.BusObj;
using Bso.Archive.BusObj.Utility;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace BSO.Archive.BusObj.Test
{
    /// <summary>
    ///This is a test class for InstrumentTest and is intended
    ///to contain all InstrumentTest Unit Tests
    ///</summary>
    [TestClass()]
    public class InstrumentTest
    {
        /// <summary>
        ///A test for GetInstrumentFromNode
        ///</summary>
        [TestMethod()]
        public void GetInstrumentFromNodeTest()
        {
            var artistInstrument = Helper.CreateXElement(Constants.Artist.artistInstrumentElement, "TestInstr");
            var artistInstrument2 = Helper.CreateXElement(Constants.Artist.artistInstrument2Element, "TestInstr2");
            var artistInstrumentID = Helper.CreateXElement(Constants.Artist.artistInstrumentIDElement, "-1");
            var node = new System.Xml.Linq.XElement(Constants.Artist.artistElement, artistInstrumentID, artistInstrument, artistInstrument2);

            Instrument instrument = Instrument.GetInstrumentFromNode(node);
            Assert.IsNotNull(instrument);
            Assert.IsTrue(instrument.InstrumentID == -1 && instrument.Instrument1 == "TestInstr");
        }

        [Ignore]
        [TestMethod]
        public void UpdateInstrumentTest()
        {
            Instrument testInstrument = Instrument.GetInstrumentByID(-1);
            if (testInstrument.IsNew)
            {
                testInstrument.InstrumentID = -1;
            }
            testInstrument.Instrument1 = "Adage";
            BsoArchiveEntities.Current.Save();

            var instrumentID = Helper.CreateXElement(Constants.Artist.artistInstrumentIDElement, "-1");
            var instrument1 = Helper.CreateXElement(Constants.Artist.artistInstrumentElement, "Test");

            var artistItem = new System.Xml.Linq.XElement(Constants.Artist.artistElement, instrumentID, instrument1);
            var eventItem = new System.Xml.Linq.XElement(Constants.Event.eventElement, artistItem);
            var doc = new System.Xml.Linq.XDocument(eventItem);

            Instrument instrument = Instrument.NewInstrument();
            instrument.UpdateData(doc, "Instrument1", Constants.Artist.artistInstrumentElement);

            Assert.IsTrue(testInstrument.Instrument1 == "Test");
            BsoArchiveEntities.Current.DeleteObject(testInstrument);
            BsoArchiveEntities.Current.DeleteObject(instrument);
            BsoArchiveEntities.Current.Save();
        }
    }
}