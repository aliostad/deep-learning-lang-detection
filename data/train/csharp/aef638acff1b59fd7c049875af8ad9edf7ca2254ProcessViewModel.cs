using System;
using System.ComponentModel;
using System.Diagnostics;
using System.Threading;
using GalaSoft.MvvmLight;
using OneDbgClient.Framework;

namespace OneDbgClient.ViewModels
{
    public class ProcessViewModel : CommonViewModel
    {
        private int _pid;
        private string _name;
        private string _processType;
        private Process _innerProcess;

        public int PID
        {
            get { return _pid; }
            set
            {
                _pid = value;
                RaisePropertyChanged();
            }
        }
        public string Name
        {
            get { return _name; }
            set
            {
                _name = value;
                RaisePropertyChanged();
            }
        }
        public string ProcessType
        {
            get { return _processType; }
            set
            {
                _processType = value; 
                RaisePropertyChanged();
            }
        }
        public Process InnerProcess
        {
            get { return _innerProcess; }
            set
            {
                _innerProcess = value; 
                RaisePropertyChanged();
            }
        }

        public ProcessViewModel(Process process)
        {
            ReadProcess(process);
        }

        private void ReadProcess(Process process)
        {
            PID = process.Id;
            Name = process.ProcessName;
            ProcessType = process.VirtualMemorySize == process.VirtualMemorySize64 ? "x86" : "x64";
            InnerProcess = process;
        }
    }
}