using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Conrad_Lib.StaticFunctions
{
    public partial class Process
    {
        public static bool KillProcess(string processName)
        {
            bool processFound = false;
            System.Diagnostics.Process[] processes = System.Diagnostics.Process.GetProcesses();
            foreach (System.Diagnostics.Process process in processes)
            {
                if (process.ProcessName == processName)
                {
                    processFound = true;
                    process.Kill();
                }
            }

            return processFound;
        }
    }
}
