using System;

namespace Whitebox.Profiler.Features.Session
{
    public class SessionConnectedEventArgs : EventArgs
    {
        readonly string _processName;
        readonly int _processId;

        public SessionConnectedEventArgs(string processName, int processId)
        {
            _processName = processName;
            _processId = processId;
        }

        public int ProcessId
        {
            get { return _processId; }
        }

        public string ProcessName
        {
            get { return _processName; }
        }
    }
}
