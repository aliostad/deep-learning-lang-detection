using Catapult.Core.Indexes;

namespace Catapult.Core.Actions
{
    public class RunningProcessInfo : IndexableBase
    {
        private readonly string _processName;
        private readonly string _title;
        private readonly int _processId;

        public RunningProcessInfo(string processName, string title, int processId)
        {
            _processName = processName;
            _title = title;
            _processId = processId;
        }

        public int ProcessId => _processId;

        public override string Name
        {
            get
            {
                if (_title.IsNullOrWhiteSpace())
                {
                    return $"{_processName} [{_processId}]";
                }

                return $"{_processName} - {_title} [{_processId}]";
            }
        }
    }
}