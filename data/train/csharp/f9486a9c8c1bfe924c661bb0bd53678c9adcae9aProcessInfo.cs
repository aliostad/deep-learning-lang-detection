namespace SPC.Controllers
{
    public class ProcessInfo
    {
        private string _processGroup;

        public string ProcessGroup
        {
            get { return _processGroup; }
        }

        private int _processId;

        public int ProcessId
        {
            get { return _processId; }
        }

        public ProcessInfo(string processGroup, string processName)
        {
            _processGroup = processGroup;

            int processId;
            _processId = int.TryParse(processName, out processId) ? processId : 0;
        }

        public bool IsValid()
        {
            return !string.IsNullOrWhiteSpace(_processGroup);
        }
    }
}