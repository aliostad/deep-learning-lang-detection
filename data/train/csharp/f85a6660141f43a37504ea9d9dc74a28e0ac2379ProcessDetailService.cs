using Processes.Models;
using Processes.Utilitys;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Processes.Services
{
    public class ProcessDetailService : IProcessDetailService
    {
        private readonly IProcessesInfosUtility _processesInfosUtility;
        private ProcessDetails[] _processDetails;

        public ProcessDetailService()
        {
            _processesInfosUtility = new ProcessesInfosUtility();
        }

        ProcessDetails[] IProcessDetailService.GetNewProcesses()
        {
            ProcessDetails[] newProcess = LoadProcesses();

            if (_processDetails == null)
            {
                _processDetails = newProcess;
                return newProcess;
            }

            var addedProcess = ExceptProcess(newProcess, _processDetails);
            if (addedProcess.Length > 0)
            {
                _processDetails = newProcess;
            }
            return addedProcess;
        }

        ProcessDetails[] IProcessDetailService.GetRemoveProcess()
        {
            ProcessDetails[] newProcess = LoadProcesses();
            if (_processDetails == null)
            {
                return null;
            }

            var removeProcess = ExceptProcess(_processDetails, newProcess);
            if (removeProcess.Length > 0)
            {
                _processDetails = newProcess;
            }
            return removeProcess;
        }

        private ProcessDetails[] ExceptProcess(ProcessDetails[] from, ProcessDetails[] except)
        {
            var fromLength = from.Length;
            var exceptLength = except.Length;

            var result = new List<ProcessDetails>(Math.Max(fromLength, exceptLength));
            for (int i = 0; i < fromLength; i++)
            {
                var isNotContains = true;
                for (int j = 0; j < exceptLength; j++)
                {
                    if (from[i].ID == except[j].ID
                        && from[i].ProcessName == except[j].ProcessName)
                    {
                        isNotContains = false;
                        break;
                    }
                }

                if (isNotContains)
                {
                    result.Add(from[i]);
                }
            }

            return result.ToArray();
        }

        private ProcessDetails[] LoadProcesses()
        {
            _processesInfosUtility.LoadProcessesNames();
            var processCount = _processesInfosUtility.Length;
            var newProcess = new ProcessDetails[processCount];
            for (int i = 0; i < processCount; i++)
            {
                newProcess[i] = _processesInfosUtility[i];
            }

            return newProcess;
        }
    }
}
