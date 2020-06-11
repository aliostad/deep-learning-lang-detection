using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using ControlPanel.Core.DataTransfer;
using ControlPanel.Core.Entities;
using ControlPanel.Service;

namespace ControlPanel.Core
{
    public class CPServiceClient
    {
        public SystemProcess GetSystemProcessByName(string processName)
        {
            //ISystemProcessService systemProcessService = IoC.Resolve<ISystemProcessService>("SystemProcessService");
            SystemProcessService systemProcessService = new SystemProcessService();
            DataTransfer<ControlPanel.Core.DataTransfer.SystemProcess.GetOutput> dt = systemProcessService.GetSystemProcessByName(processName);
            if (dt != null && dt.IsSuccess)
            {
                SystemProcess process=new SystemProcess();
                process.CopyFrom(dt.Data);
                return process;
            }
            return null;
        }


        public SystemProcessThread UpdateSystemProcessThread(SystemProcessThread processThread)
        {
           // ISystemProcessThreadService systemProcessThreadService = IoC.Resolve<ISystemProcessThreadService>("SystemProcessThreadService");
            SystemProcessThreadService systemProcessThreadService = new SystemProcessThreadService();
            return systemProcessThreadService.UpdateSystemProcessThread(processThread);
        }

        public SystemProcessThread GetSystemProcessThreadByName(string threadName)
        {
            SystemProcessThreadService systemProcessThreadService = new SystemProcessThreadService();
           // ISystemProcessThreadService systemProcessThreadService = IoC.Resolve<ISystemProcessThreadService>("SystemProcessThreadService");
            return systemProcessThreadService.GetSystemProcessThreadByName(threadName);
        }

        public List<SystemProcessThread> GetSystemProcessThreadsByProcessName(string processName)
        {
            SystemProcessService systemProcessService = new SystemProcessService();
           // ISystemProcessService systemProcessService = IoC.Resolve<ISystemProcessService>("SystemProcessService");
            return systemProcessService.GetSystemProcessThreadsByProcessName(processName);
        }


        public List<SystemProcess> GetAllSystemProcess()
        {
           // ISystemProcessService systemProcessService = IoC.Resolve<ISystemProcessService>("SystemProcessService");
            SystemProcessService systemProcessService = new SystemProcessService();
            DataTransfer<List<DataTransfer.SystemProcess.GetOutput>> result = systemProcessService.GetAll();
            List<SystemProcess> processes = new List<SystemProcess>();
            if (result.IsSuccess && result.Data != null && result.Data.Count > 0)
            {
                processes.CopyFrom(result.Data);
            }
            return processes;
        }

        public List<SystemProcessThread> GetSystemProcessThreadsByProcessID(int processID)
        {
            //ISystemProcessThreadService systemProcessThreadService = IoC.Resolve<ISystemProcessThreadService>("SystemProcessThreadService");
            SystemProcessThreadService systemProcessThreadService = new SystemProcessThreadService();
            return systemProcessThreadService.GetSystemProcessThreadByProcessID(processID);
        }


        public bool ToggleSystemProcessThreadContinuous(int systemProcessThreadID)
        {
           // ISystemProcessThreadService systemProcessThreadService = IoC.Resolve<ISystemProcessThreadService>("SystemProcessThreadService");
            SystemProcessThreadService systemProcessThreadService = new SystemProcessThreadService();
            return systemProcessThreadService.ToggleSystemProcessThreadContinuous(systemProcessThreadID);
        }

        public bool ToggleSystemProcessThreadEnabled(int systemProcessThreadID)
        {
           // ISystemProcessThreadService systemProcessThreadService = IoC.Resolve<ISystemProcessThreadService>("SystemProcessThreadService");
            SystemProcessThreadService systemProcessThreadService = new SystemProcessThreadService();
            return systemProcessThreadService.ToggleSystemProcessThreadEnabled(systemProcessThreadID);
        }


        public DataTransfer<List<SystemProcessThread>> GetSystemProcessThreadsByLastUpdateDate(DateTime lastUpdateDate)
        {
           // ISystemProcessThreadService systemProcessThreadService = IoC.Resolve<ISystemProcessThreadService>("SystemProcessThreadService");
            SystemProcessThreadService systemProcessThreadService = new SystemProcessThreadService();
            return systemProcessThreadService.GetSystemProcessThreadsByLastUpdateDate(lastUpdateDate);
        }


        public List<SystemEventLog> GetEventLogByLastUpdateDate(DateTime lastUpdateDate)
        {
           // ISystemEventLogService systemProcessThreadService = IoC.Resolve<ISystemEventLogService>("SystemEventLogService");
            SystemEventLogService systemProcessThreadService = new SystemEventLogService();
            return systemProcessThreadService.GetSystemEventLogsByLastUpdateDate(lastUpdateDate);
        }
    }
}
