using Deedle;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.Odbc;
using System.IO;
using VARCalculator.Model;

namespace VARCalculator.DataAccess
{
    class ReturnsDAO
    {
        public Frame<DateTime, string> instrumentPricesHistory;

        public void LoadInstrumentPricesMemory()
        {
            
            string fileName = ConfigurationManager.AppSettings["InstrumentDataFileName"].ToString();
            string fullFilePath = Environment.CurrentDirectory + "/" + fileName;
            try
            {
                Frame<int, string> instrumentPrices = Frame.ReadCsv(fullFilePath);
                instrumentPricesHistory = instrumentPrices.IndexRows<DateTime>("Date").SortRowsByKey();
            
            }
            catch(FileNotFoundException ex)
            {
                throw new DAOException(DAOException.FILE_NA, "Could not open file, check it exists or is not already in use", ex);
            }
            catch (Exception ex)
            {
                throw new DAOException(DAOException.UNKNOWN_ERROR, "Unknown error occurred when opening file", ex);
            }

        }

        public double[] getInstrumentReturns(string instrumentID, DateTime startDate, DateTime endDate)
        {

            double[] returnsArray = null;

            try
            {
                Series<DateTime, double> instrumentPricesColumn = instrumentPricesHistory.GetColumn<double>(instrumentID);
                Series<DateTime, double> instrumentPrices = instrumentPricesColumn.Between(startDate, endDate);
                Series<DateTime, double> instrumentReturns = (instrumentPrices.Diff(1) / instrumentPrices).DropMissing();

                returnsArray = new double[instrumentReturns.ValueCount];

                int i = 0;
                foreach (double instrumentReturn in instrumentReturns.Values)
                {
                    returnsArray[i] = instrumentReturn;
                    i++;
                }
            }
            catch (Exception ex)
            {
                throw new DAOException(DAOException.UNKNOWN_ERROR, "Unknown error occurred when trying to obatain returns", ex);
            }
            return returnsArray;
        }
    }
}
