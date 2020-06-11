namespace Pencil.Build
{
    using System.Diagnostics;

    sealed class ProcessAdapter : IProcess
    {
        Process process;
		
        public ProcessAdapter(Process process)
        {
            this.process = process;
        }

        public bool HasExited { get { return process.HasExited; } }

        public int ExitCode { get { return process.ExitCode; } }

        public System.IO.TextReader StandardOutput
        {
            get { return process.StandardOutput; }
        }
        
        public void WaitForExit(){ process.WaitForExit(); }
    }
}
