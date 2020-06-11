using Snippets.ProcessMgr.Handlers;

namespace Snippets.ProcessMgr.Messages
{
    public class Request
    {
        public string CorrelationId { get; }
        public ProcessName Process { get; }

        public Request(string correlationId, ProcessName process)
        {
            CorrelationId = correlationId;
            Process = process;
        }
    }

    public class Reply
    {
        public string CorrelationId { get; }
        public ProcessName Process { get; }

        public Reply(string correlationId, ProcessName process)
        {
            CorrelationId = correlationId;
            Process = process;
        }
    }
}