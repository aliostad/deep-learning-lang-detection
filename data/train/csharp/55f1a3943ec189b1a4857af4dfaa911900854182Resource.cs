using System;
using System.Linq;
using System.Diagnostics;
using System.Collections.Generic;

namespace Plants_vs_Crackers
{
    class Resource
    {
        public string processName { get; private set; }
        public int processId { get; private set; }
        private Resource(string processName, int processId)
        {
            this.processName = processName;
            this.processId = processId;
        }
        private static IEnumerable<Process> getTargetProcess(ref string targetProcessName)
        {
            if (targetProcessName.IndexOf(".exe") != -1)
                targetProcessName = targetProcessName.Substring(0, targetProcessName.IndexOf(".exe"));
            IEnumerable<Process> targetProcess = Process.GetProcessesByName(targetProcessName).AsEnumerable();
            if ( ( targetProcess.Count() >= 1 ) && ( targetProcess.First().Id != -1 ) )
            {
                return targetProcess;
            }
            return null;
        }
        public Resource getProcessResource(string targetProcessName)
        {
            if (targetProcessName == null)
                return null;
            IEnumerable<Process> targetProcess;
            if ( ( targetProcess = getTargetProcess(ref targetProcessName) ) != null ) {

            }
        }
    }
}
