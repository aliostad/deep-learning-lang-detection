using System.Diagnostics;

namespace MongoDB.Testing
{
    internal static class ProcessExtensions
    {
        public static IProcess AsIProcess(this Process process)
        {
            return new ProcessFacade(process);
        }

        private class ProcessFacade : IProcess
        {
            private readonly Process _process;

            public ProcessFacade(Process process)
            {
                _process = process;
            }

            public int Id
            {
                get { return _process.Id; }
            }

            public ProcessStartInfo StartInfo
            {
                get { return _process.StartInfo; }
            }

            public void Kill()
            {
                _process.Kill();
            }

            public void WaitForExit()
            {
                _process.WaitForExit();
            }
        }
    }
}