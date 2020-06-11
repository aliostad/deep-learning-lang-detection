using System.Collections.Generic;
using SolucionesARWebsite2.Models;

namespace SolucionesARWebsite2.DataAccess.Interfaces
{
    public interface ICreditProcessesRepository
    {
        int AddCreditProcess(CreditProcess creditProcess);

        void UpdateCreditProcess(CreditProcess creditProcess);

        List<CreditProcess> GetAllCreditProcesses();

        List<CreditProcess> GetCreditProcesses();

        CreditProcess GetCreditProcess(int creditProcessId);

        List<CreditProcessXCompany> GetFlowsPerCreditProcess(int creditProcessId);

        int AddCreditProcessFlow(CreditProcessXCompany creditProcessFlow);

        void UpdateCreditProcessFlow(CreditProcessXCompany creditProcessFlow);

        void DeleteCreditProcessFlow(CreditProcessXCompany creditProcessFlow);

        CreditProcessXCompany GetCreditProcessXCompanyFlow(int creditProcessXCompanyId);

        List<CreditComment> GetCommentsPerCreditProcessFlow(int creditProcessId, int creditProcessXCompanyId);

        void AddCreditProcessFlowComment(CreditComment creditProcessFlowComment);

        void UpdateCreditProcessFlowComment(CreditComment creditProcessFlowComment);
    }
}
