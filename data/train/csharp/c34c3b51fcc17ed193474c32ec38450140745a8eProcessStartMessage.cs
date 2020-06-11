using GalaSoft.MvvmLight.Messaging;
using GrSU.ProcessExplorer.Model;
using System;

namespace GrSU.ProcessExplorer.Clients.WPF.Messages
{
    public class ProcessStartMessage : MessageBase
    {
        public Process Process { get; private set; }

        public Action<Process, StartedProcessAction> Callback { get; private set; }

        public ProcessStartMessage(Process process, Action<Process, StartedProcessAction> callback)
        {
            this.Process = process;
            this.Callback = callback;
        }
    }
}
