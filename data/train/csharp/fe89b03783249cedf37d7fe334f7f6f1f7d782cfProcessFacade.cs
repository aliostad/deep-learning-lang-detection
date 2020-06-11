using System;
using System.Diagnostics;
using System.Windows.Forms;

namespace WimpKeys
{
    public interface IProcessFacade
    {
        ProcessStartInfo StartInfo { get; set; }
        Process[] GetProcessByName(string processname);
        bool Start();
    }

    public class ProcessFacade : IProcessFacade
    {
        public ProcessStartInfo StartInfo { get; set; }
        private Process _process;

        public ProcessFacade(Process process)
        {
            _process = process;
        }

        public Process[] GetProcessByName(string processname)
        {
            return Process.GetProcessesByName(processname);
        }

        public bool Start()
        {
            _process.StartInfo = StartInfo;
            return _process.Start();
        }
    }
}