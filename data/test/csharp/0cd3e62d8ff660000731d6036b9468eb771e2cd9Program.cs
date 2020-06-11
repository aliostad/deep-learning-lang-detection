using System;
using System.Diagnostics;

namespace ProcessModuleList
{
    class Program
    {
        static void Main(string[] args)
        {
            Process process = GetTargetProcess("notepad");

            if (process != null)
            {
                int processId = process.Id;
                string processName = process.ProcessName;
                string programFilename;
                try
                {
                    programFilename = process.MainModule.FileName;
                }
                catch (Exception)
                {
                    programFilename = "unknown";
                }

                Console.WriteLine("{0}: {1} - {2}", processId, processName, programFilename);

                foreach (ProcessModule processModule in process.Modules)
                {
                    Console.WriteLine(processModule.FileName);
                }
            }
        }

        static Process GetTargetProcess(string processName)
        {
            Process[] processes = Process.GetProcessesByName(processName);

            if (0 < processes.Length)
            {
                return processes[0];
            }
            else
            {
                return null;
            }
        }
    }
}
