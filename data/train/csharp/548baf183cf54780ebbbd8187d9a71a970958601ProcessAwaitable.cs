using System.Diagnostics;
using System.Threading.Tasks;

namespace CustomAwaiter
{
    class ProcessAwaitable
    {
        private readonly CustomProcessAwaiter _awaiter;

        public ProcessAwaitable()
        { }

        private ProcessAwaitable(CustomProcessAwaiter awaiter)
        {
            _awaiter = awaiter;
        }

        public ProcessAwaitable Wait(Process process)
        {
            var awaiter = new CustomProcessAwaiter();

            Task.Run(() =>
            {
                while (!process.HasExited)
                {
                    
                }

                awaiter.SetCompleted();
            });

            return new ProcessAwaitable(awaiter);
        }

        public CustomProcessAwaiter GetAwaiter() => _awaiter;
    }
}
