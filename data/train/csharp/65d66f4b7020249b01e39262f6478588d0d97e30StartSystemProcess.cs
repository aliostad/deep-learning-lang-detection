using System.ComponentModel.Composition;
using SystemInterfaces;
using CommonMessages;

namespace EventMessages.Commands
{
    [Export(typeof(IStartSystemProcess))]

    public class StartSystemProcess:ProcessSystemMessage, IStartSystemProcess
    {
        public StartSystemProcess() { }
        public int ProcessToBeStartedId { get; }

        public StartSystemProcess(int processId,IStateCommandInfo processInfo, ISystemProcess process, ISystemSource source):base(processInfo, process, source)
        {
            ProcessToBeStartedId = processId;
        }
    }
}
