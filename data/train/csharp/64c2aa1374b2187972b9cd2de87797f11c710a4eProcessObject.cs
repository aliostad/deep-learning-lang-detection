using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Alice
{
    class ProcessObject
    {
        public ProcessObject()
        {
        }

        public ProcessObject(string processName, int processId, DateTime started)
        {
            ProcessName = processName;
            ProcessId = processId;
            Started = started;
        }
        public string ProcessName { get; set; }
        public int ProcessId { get; set; }
        public DateTime Started { get; set; }
    }
}
