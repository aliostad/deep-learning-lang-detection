using System;
using System.Diagnostics;

namespace CoreLogic
{
    public abstract class IProcessFinder : IDisposable
    {
        public delegate void ProcessEventDelegate(Process process);
        public event ProcessEventDelegate ProcessStarted;
        public delegate void ProcessIDEventDelegate(int pid);
        public event ProcessIDEventDelegate ProcessStopped;

        public abstract void Dispose();

        protected void RunProcessStarted(Process process)
        {
            if (ProcessStarted != null)
            {
                ProcessStarted(process);
            }
        }

        protected void RunProcessStopped(int process)
        {
            if (ProcessStopped != null)
            {
                ProcessStopped(process);
            }
        }

        public virtual void FindAll()
        {
            if (ProcessStarted != null)
            {
                foreach (Process p in Process.GetProcesses())
                {
                    ProcessStarted(p);
                }
            }
        }
    }
}
