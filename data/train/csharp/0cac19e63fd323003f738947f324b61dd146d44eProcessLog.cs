using System;
using CLRViaCsharp.Events.EventArgs;

namespace CLRViaCsharp.Events
{
    internal class ProcessLog
    {
        private readonly Guid _processorId;
        private Guid _processId;
        private readonly DateTime _processStarted;
        private DateTime _processDone;

        public Guid ProcessorId
        {
            get => _processorId;
            set => _processId = value;
        }


        public Guid ProcessId
        {
            get => _processId;
            set => _processId = value;
        }

        public DateTime ProcessStarted => _processStarted;
        public DateTime ProcessDone
        {
            get => _processDone;
            set => _processDone = value;
        }


        public ProcessLog(Processor processor, ProcessStartedEventArgs processStartedEventArgs)
        {
            _processorId = processor.Id;
            _processId = processStartedEventArgs.ProcessId;
            _processStarted = processStartedEventArgs.Start;
        }

    }
}
