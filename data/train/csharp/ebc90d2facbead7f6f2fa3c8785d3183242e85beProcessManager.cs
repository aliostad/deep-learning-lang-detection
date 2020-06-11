using GrSU.ProcessExplorer.Core.Native.Kernel32;
using GrSU.ProcessExplorer.Core.WMI;
using GrSU.ProcessExplorer.Interfaces;
using GrSU.ProcessExplorer.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using GrSU.ProcessExplorer.Core.Mapping;

namespace GrSU.ProcessExplorer.Core
{
    public class ProcessManager : IProcessManager
    {
        public event ProcessStart ProcessStart;

        public event ProcessStop ProcessStop;

        internal readonly ProcessHandler ProcessHandler;

        internal readonly ProcessEventManager ProcessEventManager;

        public ProcessManager()
        {
            this.ProcessEventManager = new ProcessEventManager();
            this.ProcessEventManager.ProcessStart += processEventManagerProcessStart;
            this.ProcessEventManager.ProcessStop += processEventManagerProcessStop;

            this.ProcessHandler = new ProcessHandler();
        }

        private void processEventManagerProcessStop(object sender, ProcessChangeStateEventArgs e)
        {
            this.OnProcessStop(e.ProcessId);
        }

        private void processEventManagerProcessStart(object sender, ProcessChangeStateEventArgs e)
        {
            var process = this.GetProcess(e.ProcessId);
            this.OnProcessStart(process);
        }

        public IEnumerable<Process> GetProcesses()
        {
            return this.ProcessHandler.GetProcesses()
                .Select(item => item.Map<Process>());
        }

        public Process GetProcess(uint id)
        {
            var processEntry = this.ProcessHandler.GetProcess(id);
            return processEntry.HasValue ? processEntry.Value.Map<Process>() : null;
        }

        public void KillProcess(uint id)
        {
            this.ProcessHandler.KillProcess(id);
        }

        private void OnProcessStart(Process process)
        {
            if (ProcessStart == null)
            {
                return;
            }

            ProcessStart(this, new ProcessStartEventArgs
            {
                Process = process
            });
        }

        private void OnProcessStop(uint processId)
        {
            if (ProcessStop == null)
            {
                return;
            }

            ProcessStop(this, new ProcessStopEventArgs
            {
                ProcessId = processId
            });
        }

        public void Dispose()
        {
            if (this.ProcessEventManager != null)
            {
                this.ProcessEventManager.Dispose();
            }
        }
    }
}
