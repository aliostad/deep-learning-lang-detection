using System.Linq;
using System.Threading.Tasks;
using IronFrame.Messages;
using IronFrame.Utilities;

namespace IronFrame.Host.Handlers
{
    internal class FindProcessByIdHandler
    {
        readonly IProcessTracker processTracker;

        public FindProcessByIdHandler(IProcessTracker processTracker)
        {
            this.processTracker = processTracker;
        }

        public Task<FindProcessByIdResult> ExecuteAsync(FindProcessByIdParams p)
        {
            IProcess process;
            var processKey = processTracker.GetProcessById(p.id, out process);
            if (process == null)
            {
                return Task.FromResult(null as FindProcessByIdResult);
            }

            var result = new FindProcessByIdResult
            {
                id = process.Id,
                processKey = processKey,
                environment = process.Environment
            };

            return Task.FromResult(result);
        }
    }
}
