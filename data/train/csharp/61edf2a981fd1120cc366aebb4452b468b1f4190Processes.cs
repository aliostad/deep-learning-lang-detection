using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GetProcessCPUPercent
{
    public class Processes
    {

        #region constant 

        const Process CLOSED_PROCESS = null;
        const ProcessInfo PROCESS_INFO_NOT_FOUND = null;

        #endregion 

        #region properties

        public ProcessInfo[] ProcessList;
        private int _processIndex;
        private float _currentLoadPercent;
        private Process[] _newProcessList;

        #endregion 

        #region ctor

        public Processes()
        {
            _newProcessList = Process.GetProcesses();
            ProcessList = new ProcessInfo[_newProcessList.Length];
            AddNewProcesses();
        }

        public void Update(float currentLoadPercent)
        { 
            _currentLoadPercent = currentLoadPercent;
            UpdateExistingProcesses();
        }

        #endregion


        #region private methods 

        private void AddNewProcesses()
        {
            foreach (Process NewProcess in _newProcessList)
                if (!ProcessInfoExists(NewProcess))
                    AddNewProcess(NewProcess);
        }

        private void AddNewProcess(Process NewProcess)
        {
            ProcessInfo NewProcessInfo = new ProcessInfo();

            NewProcessInfo.Name = NewProcess.ProcessName;
            NewProcessInfo.ID = NewProcess.Id;

            ProcessList[_processIndex++] = GetProcessInfo(NewProcessInfo, NewProcess);
        }

        private Process ProcessExists(Process[] NewProcessList, int ID)
        {
            foreach (Process TempProcess in NewProcessList)
                if (TempProcess.Id == ID)
                    return TempProcess;

            return CLOSED_PROCESS;
        }

        private bool ProcessInfoExists(Process NewProcess)
        {
            if (ProcessList == null) return false;

            foreach (ProcessInfo TempProcess in ProcessList)
                if (TempProcess != PROCESS_INFO_NOT_FOUND && TempProcess.ID == NewProcess.Id)
                    return true;

            return false;
        }

        private ProcessInfo GetProcessInfo(ProcessInfo TempProcess, Process CurrentProcess)
        {
            try
            {
                long NewCpuUsage = (long)CurrentProcess.TotalProcessorTime.TotalMilliseconds;

                TempProcess.CpuUsage = ((NewCpuUsage - TempProcess.OldCpuUsage) / _currentLoadPercent);
                TempProcess.OldCpuUsage = NewCpuUsage;
            }
            catch (Exception) { }

            return TempProcess;
        }

        private void UpdateExistingProcesses()
        {

            ProcessInfo[] TempProcessList = new ProcessInfo[_newProcessList.Length];
            _processIndex = 0;

            foreach (ProcessInfo TempProcess in ProcessList)
            {
                Process CurrentProcess = ProcessExists(_newProcessList, TempProcess.ID);
                TempProcessList[_processIndex++] = GetProcessInfo(TempProcess, CurrentProcess);
            }
            ProcessList = TempProcessList;
        }

        #endregion

    }
}
