using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.ComponentModel;

namespace Compacter
{
    using _Process = System.Diagnostics.Process;

    public class ProcessList : Component
    {
        public delegate void ProcessEventHandler(Process Process);
        public event ProcessEventHandler ProcessStarted;
        public event ProcessEventHandler ProcessTerminated;

        private Dictionary<int, Process> ProcessesByID = new Dictionary<int, Process>();

        public ProcessList()
        {
        }

        private void AddProcess(_Process _Process)
        {
            Process Process = new Process(_Process);
            this.ProcessesByID.Add(Process.Id, Process);

            if (this.ProcessStarted != null)
            {
                this.ProcessStarted(Process);
            }
            Process.Exited += this.Process_Exited;
        }

        private void Process_Exited(Process Process)
        {
            this.RemoveProcess(Process);
        }

        private void RemoveProcess(Process Process)
        {
            if (!this.ProcessesByID.ContainsKey(Process.Id))
            {
                return;
            }
            if (this.ProcessTerminated != null)
            {
                this.ProcessTerminated(this.ProcessesByID[Process.Id]);
            }
            this.ProcessesByID.Remove(Process.Id);
        }

        public void Update()
        {
            _Process[] Processes = _Process.GetProcesses();
            foreach (_Process Proc in Processes)
            {
                if (this.ProcessesByID.ContainsKey(Proc.Id))
                {
                    continue;
                }
                this.AddProcess(Proc);
            }

            Dictionary<int, _Process> CurrentProcesses = new Dictionary<int, _Process>(Processes.ToDictionary(delegate(_Process Proc) { return Proc.Id; }));
            List<Process> TerminatedProcesses = new List<Process>();

            foreach (Process Proc in this.ProcessesByID.Values)
            {
                if (!CurrentProcesses.ContainsKey(Proc.Id) || !Proc.IsSameProcess (CurrentProcesses[Proc.Id]))
                {
                    TerminatedProcesses.Add(Proc);
                }
            }

            foreach (Process Proc in TerminatedProcesses)
            {
                Proc.OnExited();
            }
        }
    }
}
