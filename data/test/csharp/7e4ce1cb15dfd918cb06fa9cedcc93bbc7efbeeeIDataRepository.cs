using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace DataRepository
{
    public interface IDataRepository
    {
        List<Instrument> GetInstruments();

        int GetTestIdByInstrumentAndTestCode(int instrumentId, string testCode);

        bool InstrumentResult(string orderNumber, int testId, string value, string instrumentPatient, int instrumentId);

        List<InstrumentResult> GetAllValidInstrumentResultByCondition(DateTime? receivedDate, string orderNumber, int? instrumentId);

        bool InsertToResult(int? orderNumber, DateTime? receivedDate, int? testId, string value, int? instrumentResultId);
    }
}
