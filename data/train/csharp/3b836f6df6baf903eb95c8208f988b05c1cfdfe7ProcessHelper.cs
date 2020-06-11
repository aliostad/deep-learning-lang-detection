using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

using System.Diagnostics;
using System.Threading;

namespace Utilities
{
    public class ProcessHelper
    {

        public static void killProcess(Process p_Process)
        {
            p_Process.Kill();
            Thread.Sleep(3000);
        }

        public static void cleanupProcesses(string pProcessName)
        {
            Process[] l_ProcessList = Process.GetProcessesByName(pProcessName);
            foreach (Process process in l_ProcessList)
                killProcess(process);
        }
    }
}
