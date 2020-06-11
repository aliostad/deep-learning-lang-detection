using MvvX.ProcessManager.Core;
using System.Diagnostics;

namespace MvvX.ProcessManager
{
    public class ProcessManager : IProcessManager
    {
        public IProcessResult StartProcess(string filePath)
        {
            var process = Process.Start(filePath);
            if (process != null)
                return new ProcessResult(process, true);

            return null;
        }

        public IProcessResult StartProcess(string filePath, string arguments)
        {
            var process = Process.Start(filePath, arguments);
            if (process != null)
                return new ProcessResult(process, true);

            return null;
        }
    }
}
