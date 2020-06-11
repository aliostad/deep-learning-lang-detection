using System;
using System.Linq;
using System.Diagnostics;
using System.Collections.Generic;

namespace Plants_vs_Crackers
{
    class Program
    {
        static void Main(string[] args)
        {
            ProcessHandler processHandler = ProcessHandler.getProcessHandler("popcapgame1.exe");
            IntPtr processPointer = Interop.GetTargetProcessAccess(processHandler);
            IntPtr loadLibraryPointer = Interop.GetLoadLibraryANSIProcessAddress();
            string dllName = "foo.exe";
            IntPtr processAllocation = Interop.SetTargetProcessVirtualAllocation(processPointer, dllName);
            Console.WriteLine();
        }
    }

    class ProcessHandler
    {
        //Instance Variables
        public string processName { get; private set; }
        public int processId { get; private set; }
        
        private const int ZERO_INDEX = 0;

        private ProcessHandler(string processName, int processId)
        {
            this.processName = processName;
            this.processId = processId;
        }

        private static IEnumerable<Process> findTargettedProcess(ref string targetProcessName)
        {
            if (targetProcessName.IndexOf(".exe") != -1)
                targetProcessName = targetProcessName.Substring(0, (targetProcessName.IndexOf(".exe")));
            IEnumerable<Process> targetProcess = Process.GetProcessesByName(targetProcessName).AsEnumerable();
            if ((targetProcess.Count() == 1) && (targetProcess.First().Id) != -1)
            {
                return targetProcess;
            }
            return null;
        }


        // Factory function for Process Handler. 
        // With given targetName string parameter, getProcessHanler attempts to find an 
        // associated process currently running on the OS and returns an instance object 
        // if successful. 
        public static ProcessHandler getProcessHandler(string targetProcessName)
        {
            IEnumerable<Process> targetProcess;
            if ((targetProcess = findTargettedProcess(ref targetProcessName)) != null)
            {
                return new ProcessHandler(targetProcessName, targetProcess.First().Id);
            }
            return null; 
        }
    }
}
