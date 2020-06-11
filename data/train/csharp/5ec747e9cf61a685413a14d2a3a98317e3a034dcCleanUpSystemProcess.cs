using System.ComponentModel.Composition;
using SystemInterfaces;
using CommonMessages;

namespace EventMessages.Commands
{
    [Export(typeof(ICleanUpSystemProcess))]
    public class CleanUpSystemProcess : ProcessSystemMessage, ICleanUpSystemProcess
    {
        public CleanUpSystemProcess() { }
        public int ProcessToBeCleanedUpId { get; }

        public CleanUpSystemProcess(int processId, IStateCommandInfo processInfo, ISystemProcess process, ISystemSource source) : base(processInfo, process, source)
        {
            ProcessToBeCleanedUpId = processId;
        }
    }
}