using System;

namespace Plaisted.ProcessMonitor
{
    internal class TrackedProcess
    {
        public int ProcessId { get; set; }
        public int ParentProcessId { get; set; }
        public string ProcessName { get; set; }
        public UInt64 Started { get; set; }
        public UInt64 Ended { get; set; }

        public bool IsParentOf(TrackedProcess process)
        {
            return process.ParentProcessId == ProcessId && process.Started > Started && (Ended == 0 || Ended > process.Started);
        }
        public bool IsChildOf(TrackedProcess process)
        {
            return ParentProcessId == process.ProcessId && Started > process.Started && (process.Ended == 0 || Started < process.Ended);
        }
    }
}