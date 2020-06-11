using System.Collections.Generic;
using ProcessRouting.Messaging;

namespace ProcessRouting.ProcessManagment
{
    public class ProcessState
    {
        private readonly IList<ProcessStep> _completedProcessStep;
        private readonly IList<MessageType> _receivedMessages;
        private readonly IList<ProcessStep> _startedProcessSteps;

        public ProcessState()
        {
            _startedProcessSteps = new List<ProcessStep>();
            _completedProcessStep = new List<ProcessStep>();
            _receivedMessages = new List<MessageType>();
        }

        public IEnumerable<ProcessStep> CompletedProcessStep => _completedProcessStep;

        public IEnumerable<MessageType> ReceivedMessages => _receivedMessages;

        public IEnumerable<ProcessStep> StartedProcessSteps => _startedProcessSteps;

        public void ReceiveMessage(MessageType messageType)
        {
            _receivedMessages.Add(messageType);
        }

        public void ProcessStarted(ProcessStep processStep)
        {
            _startedProcessSteps.Add(processStep);
        }

        public void CompleteStep(ProcessStep processStep)
        {
            _completedProcessStep.Add(processStep);
            _startedProcessSteps.Remove(processStep);
        }
    }
}