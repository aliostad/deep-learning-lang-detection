namespace Figlut.Server.Toolkit.Utilities
{
    #region Using Directives

    using System;
    using System.Collections.Generic;
    using System.Diagnostics;
    using System.Linq;
    using System.Text;
    using System.Threading.Tasks;

    #endregion //Using Directives

    public class ProcessHelper
    {
        #region Methods

        public static void KillProcess(string processName)
        {
            Process[] processes = Process.GetProcessesByName(processName);
            if (processes != null)
            {
                foreach (Process p in processes)
                {
                    p.Kill();
                }
            }
        }

        public static void KillCurrentProcess()
        {
            Process currentProcess = Process.GetCurrentProcess();
            if (currentProcess != null)
            {
                currentProcess.Kill();
            }
        }

        #endregion //Methods
    }
}
