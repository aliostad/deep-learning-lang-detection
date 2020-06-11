using AL.Core.Interfaces;
using AL.Core.Models;

namespace AL.Core.Reporters
{
    public class ProcessReporter : Reporter<ProcessReport>
    {
        public ProcessReport ProcessReport { get; private set; }

        private readonly IProcessReceiver _processReceiver;

        public ProcessReporter(IProcessReceiver processReceiver)
        {
            _processReceiver = processReceiver;
        }

        protected override void Act(ProcessReport processReport)
        {
            ProcessReport = processReport;

            _processReceiver.ReportProcess(processReport);
        }
    }
}
