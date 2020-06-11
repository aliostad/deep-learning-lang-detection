using FuzzyLogicSearch.DataAccess;
using FuzzyLogicSearch.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using DuoVia.FuzzyStrings;

namespace FuzzyLogicSearch.Services
{
    class InstrumentSearchService
    {
        private LevenshteinDistance distanceCalc = new LevenshteinDistance();

        public List<InstrumentSearchModel> getFilteredInstruments(string filter, List<InstrumentSearchModel> instrumentList, string selectedMatchAlgo, double threshold)
        {
            List<InstrumentModel> instruments = new List<InstrumentModel>();
            InstrumentListDAO instrumentData = new InstrumentListDAO();

            try
            {
                //Get all instruments
                instruments = instrumentData.GetData();
            }
            catch (DAOException ex)
            {
                if (ex.GetErrorCode() == DAOException.FILE_NA)
                {
                    throw new ServiceException(ServiceException.DATA_ACCESS_ERROR, "Could not get data for instruments", ex);
                }
                else if (ex.GetErrorCode() == DAOException.FILE_PARSE_ERROR)
                {
                    throw new ServiceException(ServiceException.DATA_ACCESS_ERROR, "Could not get data for instruments", ex);
                }
                else if (ex.GetErrorCode() == DAOException.UNKNOWN_ERROR)
                {
                    throw new ServiceException(ServiceException.UNKNOWN_ERROR, "Could not get data for instruments", ex);
                }
            }

            List<InstrumentSearchModel> filteredInstruments = new List<InstrumentSearchModel>();
            if (instruments != null)
            {
                //Fuzzy logic filtering
                foreach (InstrumentModel instrument in instruments)
                {
                    double distance;
                    if (selectedMatchAlgo == "Levenshtein Distance")
                    {
                        distance = (double)distanceCalc.CalculateLevenshteinDistance(filter, instrument.InstrumentName);
                    }
                    else if (selectedMatchAlgo == "Dice Coefficient")
                    {
                        distance = Math.Round(DiceCoefficientExtensions.DiceCoefficient(filter, instrument.InstrumentName), 2) * 100;
                    }
                    else
                    {
                        throw new ArgumentException("Could not find matching algorithm supplied please try again");
                    }

                    if (distance >= threshold)
                    {
                        InstrumentSearchModel instrumentSearch = new InstrumentSearchModel(instrument.Identifier, instrument.InstrumentName, distance);
                        filteredInstruments.Add(instrumentSearch);
                    }
                }
            }

            return filteredInstruments.OrderByDescending(x => x.MatchLikelihood).ToList();
        }
		
		//Currently unused method for getting all instruments with no filter
        public List<InstrumentSearchModel>  getAllInstruments()
        {
            List<InstrumentModel> instruments = new List<InstrumentModel>();
            InstrumentListDAO instrumentData = new InstrumentListDAO();
            instruments = instrumentData.GetData();
            List<InstrumentSearchModel> instrumentsList = new List<InstrumentSearchModel>();

            foreach (InstrumentModel instrument in instruments)
            {
                
                    InstrumentSearchModel instrumentSearch = new InstrumentSearchModel(instrument.Identifier, instrument.InstrumentName, 0);
                    instrumentsList.Add(instrumentSearch);
            }
            return instrumentsList.OrderByDescending(x => x.MatchLikelihood).ToList();
        }
    }
}
