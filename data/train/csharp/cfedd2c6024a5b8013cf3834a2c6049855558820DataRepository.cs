using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DataRepository
{
    public class Repository : IDataRepository
    {
        private LabnetCommunicationEntities myDb;
        public LabnetCommunicationEntities Context { get { return myDb; } }

        public Repository()
        {
            myDb = new LabnetCommunicationEntities();
        }

        public List<Instrument> GetInstruments()
        {
            List<Instrument> lstInstruments = new List<Instrument>();
            try
            {
                lstInstruments = (from _ins in myDb.Instruments where _ins.IsActive select _ins).ToList();
                
            }
            catch (Exception ex)
            {
                Console.WriteLine((ex.InnerException).Message);
            }

            return lstInstruments;
        }

        public int GetTestIdByInstrumentAndTestCode(int instrumentId, string testCode)
        {
            try
            {
                List<GetTestIdByInstrumentAndInstrumentTestCode_Result> lst = myDb.GetTestIdByInstrumentAndInstrumentTestCode(instrumentId, testCode).ToList();
                if (lst.Count > 0)
                    return lst[0].TestId;
            }

            catch (Exception ex)
            {
                Console.WriteLine((ex.InnerException).Message);
            }

            return 0;
        }

        public bool InstrumentResult(string orderNumber, int testId, string value, string instrumentPatient, int instrumentId)
        {
            try
            {
                myDb.InstrumentResult(orderNumber, testId, value, instrumentPatient, instrumentId);
                return true;
            }
            catch (Exception ex)
            {
                Console.WriteLine((ex.InnerException).Message);
            }
            return false;
        }

        public List<InstrumentResult> GetAllValidInstrumentResultByCondition(DateTime? receivedDate, string orderNumber, int? instrumentId)
        {
            try
            {
                List<InstrumentResult> lstInstrumentResults = (from _insResult in myDb.InstrumentResults
                                                               where _insResult.Flag == false
                                                                 && _insResult.ReceivedDate == receivedDate
                                                                 && (orderNumber == null || _insResult.OrderNumber == orderNumber)
                                                                 && (instrumentId == null || _insResult.InstrumentId == instrumentId)
                                                               select _insResult).ToList();
                return lstInstrumentResults;
            }

            catch (Exception ex)
            {
                Console.WriteLine((ex.InnerException).Message);
            }

            return new List<InstrumentResult>();
        }

        public bool InsertToResult(int? orderNumber, DateTime? receivedDate, int? testId, string value, int? instrumentResultId)
        {
            try
            {
                myDb.Result(orderNumber, receivedDate, testId, value, instrumentResultId);
                return true;
            }

            catch (Exception ex)
            {
                Console.WriteLine((ex.InnerException).Message);
            }

            return false;
        }
    }
}
