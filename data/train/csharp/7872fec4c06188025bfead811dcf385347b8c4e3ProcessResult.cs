using System.Diagnostics;

namespace Foundation.Windows
{
    public class ProcessResult : IProcessResult
    {
        readonly Process process;

        public ProcessResult(Process process)
        {
            this.process = process;
        }

        public string StandardOutput
        {
            get { return process.StandardOutput.ReadToEnd(); }
        }

        public string StandardError
        {
            get { return process.StandardError.ReadToEnd(); }
        }

        public int ExitCode
        {
            get { return process.ExitCode; }
        }
    }
}