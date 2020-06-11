using System;
using Hangfire.Annotations;
using Hangfire.Server;

namespace Hangfire.Async.Server.Infrastructure.Compatibility
{
    internal class InfiniteLoopProcess : IBackgroundProcess
    {
        public InfiniteLoopProcess([NotNull] IBackgroundProcess innerProcess)
        {
            if (innerProcess == null) throw new ArgumentNullException(nameof(innerProcess));
            
            InnerProcess = innerProcess;
        }
        
        public IBackgroundProcess InnerProcess { get; }

        public void Execute(BackgroundProcessContext context)
        {
            while (!context.IsShutdownRequested)
            {
                InnerProcess.Execute(context);
            }
        }

        public override string ToString()
        {
            return InnerProcess.ToString();
        }
    }
}