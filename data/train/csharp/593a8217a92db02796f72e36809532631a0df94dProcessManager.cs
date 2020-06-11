using System.Collections.Generic;
using System.Net.Configuration;
using System.Text;
using System.Threading.Tasks;
using Akka.Actor;

namespace ProcessManager
{
    public class ProcessManager : ReceiveActor
    {
        private readonly Dictionary<string, IActorRef> _processes = new Dictionary<string, IActorRef>();

        protected IActorRef ProcessOf(string processId)
        {
            if (_processes.ContainsKey(processId))
            {
                return _processes[processId];
            }
            return null;
        }

        protected void StartProcess(string processId, IActorRef process)
        {
            if (!_processes.ContainsKey(processId))
            {
                _processes.Add(processId, process);
                Self.Tell(new ProcessStarted(processId, process));
            }    
        }

        protected void StopProcess(string processId)
        {
            if (_processes.ContainsKey(processId))
            {
                var process = _processes[processId];
                _processes.Remove(processId);
                Self.Tell(new ProcessStopped(processId, process));
            }
        }
    }

    public class ProcessStopped
    {
        public string ProcessId { get; }
        public IActorRef Process { get; }

        public ProcessStopped(string processId, IActorRef process)
        {
            ProcessId = processId;
            Process = process;
        }
    }

    public class ProcessStarted
    {
        public string ProcessId { get; }
        public IActorRef Process { get; }

        public ProcessStarted(string processId, IActorRef process)
        {
            ProcessId = processId;
            Process = process;
        }
    }
}
