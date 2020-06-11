using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Diagnostics;

namespace SingleSignOn
{
    public class ProcessManager
    {
        /// <summary>
        /// Starts the specified process.
        /// </summary>
        /// <param name="processName">Name of the process.</param>
        public static void StartProcess(string processName)
        {
            bool alreadyStarted = Process.GetProcessesByName(processName).Count() > 0;
            if (!alreadyStarted)
            {
                ProcessStartInfo processStartInfo = new ProcessStartInfo(processName);
                Process.Start(processStartInfo);
            }
        }
    }
}
