using System;
using System.ComponentModel;
using System.Diagnostics;

namespace Projekt2
{
    public class MyProcess
    {
        private Process process { set; get; }

        public event PropertyChangedEventHandler PropertyChanged;

        public void RaisePropertyChanged(string propertyName)
        {
            if (PropertyChanged != null)
            {
                PropertyChanged(this, new PropertyChangedEventArgs(propertyName));
            }
        }

        public Process Process
        {
            get
            {
                return process;
            }
            set
            {
                if (process != value)
                {
                    process = value;
                    RaisePropertyChanged("Process");
                }
            }
        }

        public string Name
        {
            get
            {
                return process.ProcessName;
            }
        }

        public string ID
        {
            get
            {
                return String.Format("{0,5}",process.Id);
            }
        }

        public MyProcess(Process process)
        {
            this.process = process;
        }

        public override string ToString()
        {
            return String.Format("{0,-30}{1,8}",process.ProcessName,process.Id);
        }
    }
}
