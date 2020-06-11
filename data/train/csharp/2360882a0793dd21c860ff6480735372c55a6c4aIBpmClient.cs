using BonitasRestClient.Models;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BonitasRestClient.Contracts
{
    public interface IBpmClient
    {
        Task<Case> GetCaseAsync(string caseId);
        Case GetCase(string caseId);
        Task<IList<Case>> GetCasesAsync();
        IList<Case> GetCases();
        Task<Process> GetProcessAsync(string processId);
        Process GetProcess(string processId);
        Task<IList<Process>> GetProcessesAsync();
        IList<Process> GetProcesses();
        Task<ProcessConstraints> GetProcessConstraintsAsync(string processId);
        ProcessConstraints GetProcessConstraints(string processId);
        Task ExecuteProcessAsync(string processId, JObject payload);
        void ExecuteProcess(string processId, JObject payload);
        Task<Process> UpdateProcessAsync(string processId, ProcessUpdateFields fields);
        Process UpdateProcess(string processId, ProcessUpdateFields fields);
    }
}
