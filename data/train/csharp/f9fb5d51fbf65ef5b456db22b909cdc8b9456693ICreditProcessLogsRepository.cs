using System.Collections.Generic;
using SolucionesARWebsite2.Models;

namespace SolucionesARWebsite2.DataAccess.Interfaces
{
    public interface ICreditProcessLogsRepository
    {
        void AddCreditProcessLog(CreditProcessLog creditProcessLog);

        void EditCreditProcessLog(CreditProcessLog creditProcessLog);

        List<CreditProcessLog> GetAllCreditProcessLogs();

        List<CreditProcessLog> GetCreditProcessLogs();

        CreditProcessLog GetCreditProcessLogs(int creditProcessLogId);
    }
}