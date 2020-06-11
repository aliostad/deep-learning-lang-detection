using System;
using System.Diagnostics;

namespace ProcessList
{
    class Program
    {

        static void Main(string[] args)
        {
            foreach (Process process in Process.GetProcesses())
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
            }
        }

    }
}
