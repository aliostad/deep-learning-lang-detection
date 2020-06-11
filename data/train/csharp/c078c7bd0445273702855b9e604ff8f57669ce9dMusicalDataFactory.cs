/// Author: Thomas Diego Prananta, 2016
/// All rights reserved

using System.Linq;
using System.IO;
using System.Diagnostics;
using System.Collections.Generic;

using CsvHelper;

using MusicalTracker.DAL.Interfaces;
using MusicalTracker.DAL.Concretes;

namespace MusicalTracker.DAL
{
    /// <summary>
    /// A factory class that provides access to the borrowed instrument data
    /// </summary>
    public class MusicalDataFactory
    {
        /// Loads a list of IMusicInstrument given the paths to
        /// the music instrument csv file and instrument borrower file
        /// Throws an exception
        public List<IMusicInstrument> LoadBorrowedInstruments (
            string instrumentsFile, string borrowersFile)
        {
            List<MusicInstrumentSalesForce> instrumentList = null;
            List<MusicInstrumentBorrowerSalesForce> borrowerList = null;

            using (StreamReader textReader = File.OpenText(instrumentsFile))
            {
                CsvReader csv = new CsvReader(textReader);
                instrumentList = csv.GetRecords<MusicInstrumentSalesForce>().ToList();
            }

            using (StreamReader textReader = File.OpenText(borrowersFile))
            {
                CsvReader csv = new CsvReader(textReader);
                borrowerList = csv.GetRecords<MusicInstrumentBorrowerSalesForce>().ToList();
            }

            List<IMusicInstrument> borrowedInstruments = new List<IMusicInstrument>();
            foreach (MusicInstrumentSalesForce instrument in instrumentList)
            {
                if (!string.IsNullOrEmpty(instrument.BORROWED_BY__C))
                {
                    var borrower = borrowerList.First(x => x.ID == instrument.BORROWED_BY__C);
                    Debug.Assert(null != borrower);
                    borrowedInstruments.Add(new MusicInstrument(instrument,borrower));
                }
            }
            return borrowedInstruments;
        }
    }
}
