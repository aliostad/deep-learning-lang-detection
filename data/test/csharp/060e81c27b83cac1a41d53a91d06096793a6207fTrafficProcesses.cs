using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Diagnostics;

namespace BlackHoleClient
{
    public class TrackedProcess
    {
        public int processID { get; set; }
        public string processName { get; set; }
        public DateTime startedTracking { get; set; }

        public TrackedProcess(Process aProcess)
        {
            processID = aProcess.Id;
            processName = aProcess.ProcessName;
            startedTracking = DateTime.Now;
        }
    }
}
