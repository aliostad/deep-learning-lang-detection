using System;

namespace Whitebox.Messages
{
    [Serializable]
    public class ProfilerConnectedMessage
    {
        readonly string _processName;
        readonly int _processId;

        public ProfilerConnectedMessage(string processName, int processId)
        {
            if (processName == null) throw new ArgumentNullException("processName");
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
