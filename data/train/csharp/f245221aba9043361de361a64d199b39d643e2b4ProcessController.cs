using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Management;
using System.Text;
using System.Windows.Forms;

namespace OSCConnect.Controllers
{
    class ProcessController
    {
        public static bool IsProcessRunning(String processName)
        {
            Process[] pname = Process.GetProcessesByName(processName);
            return ((pname.Length != 0) ? true : false);
        }

        public static bool IsProcessRunning(int processID)
        {
            try
            {
                Process pname = Process.GetProcessById(processID);
                //This should always return true, exception is thrown if process not found
                return (pname != null);
            }
            catch (Exception)
            {
                return (false);
            }
        }

        public static bool IsProcessRunning(Process process)
        {
            return IsProcessRunning(process.Id);
        }

        // This is a pretty thourough way to ensure the process dies.
        public static bool KillProcess(Process process)
        {
            if (process != null)
            {
                int processId = process.Id;
                
                if (!process.HasExited)
                {
                    process.Close();
                    Process.GetProcessById(processId).Close();

                    if (Process.GetProcessById(processId).Responding)
                    {
                        Process.GetProcessById(processId).Kill();
                    }
                }
            }
            return true;
        }
    }
}
