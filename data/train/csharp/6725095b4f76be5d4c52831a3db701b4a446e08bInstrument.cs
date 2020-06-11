using System;
using System.Collections.Generic;
using Bso.Archive.BusObj.Interface;
using System.Linq;
using System.Text;
using Bso.Archive.BusObj.Utility;

namespace Bso.Archive.BusObj
{
    partial class Instrument : IOPASData
    {

        #region IOPASData
        /// <summary>
        /// Updates the existing database Instrument on the column name using the 
        /// XML document parsed using the tagName.
        /// </summary>
        /// <param name="doc"></param>
        /// <param name="columnName"></param>
        /// <param name="tagName"></param>
        public void UpdateData(System.Xml.Linq.XDocument doc, string columnName, string tagName)
        {
            IEnumerable<System.Xml.Linq.XElement> eventElements = doc.Descendants(Constants.Artist.artistElement);
            foreach (System.Xml.Linq.XElement element in eventElements)
            {
                Instrument updateInstrument = Instrument.GetInstrumentFromNode(element);

                if (updateInstrument == null) continue;

                object newValue = element.GetXElement(tagName);

                BsoArchiveEntities.UpdateObject(updateInstrument, newValue, columnName);
            }
        }

        #endregion
        /// <summary>
        /// Get Instrument from XElement node
        /// </summary>
        /// <param name="node"></param>
        /// <returns></returns>
        public static Instrument GetInstrumentFromNode(System.Xml.Linq.XElement node)
        {
            if (node == null || node.Element(Constants.Artist.artistInstrumentIDElement) == null)
                return null;

            int instrumentID;
            int.TryParse(node.GetXElement(Constants.Artist.artistInstrumentIDElement), out instrumentID);


            Instrument instrument = Instrument.GetInstrumentByID(instrumentID);
            if (!instrument.IsNew)
                return instrument;

            SetInstrumentDetails(node, instrument, instrumentID);

            return instrument;
        }

        private static void SetInstrumentDetails(System.Xml.Linq.XElement node, Instrument instrument, int instrumentID)
        {
            instrument.InstrumentID = instrumentID;
            string artistInstrument1 = node.GetXElement(Constants.Artist.artistInstrumentElement);
            string artistInstrument2 = node.GetXElement(Constants.Artist.artistInstrument2Element);
            instrument.Instrument1 = artistInstrument1;
            instrument.Instrument2 = artistInstrument2;
        }

        public static Instrument GetInstrumentByID(int instrumentID)
        {
            Instrument instrument = BsoArchiveEntities.Current.Instruments.FirstOrDefault(i => i.InstrumentID == instrumentID) ?? Instrument.NewInstrument();

            return instrument;
        }

        internal static Instrument GetInstrumentByNames(string instrument1, string instrument2)
        {
            Instrument instrument = BsoArchiveEntities.Current.Instruments.FirstOrDefault(i => i.Instrument1 == instrument1 && i.Instrument2 == instrument2) ?? Instrument.NewInstrument();

            return instrument ;

        }

    }

}
