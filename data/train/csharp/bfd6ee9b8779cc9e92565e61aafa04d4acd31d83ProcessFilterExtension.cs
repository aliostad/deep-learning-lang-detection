using System.Diagnostics;

namespace WF45
{
    public abstract class ProcessFilterExtension
    {
        public abstract bool IsMatchingProcess(Process process);
    }

    public class StartsWithFilter : ProcessFilterExtension
    {
        private readonly string startsWith;

        public StartsWithFilter(string startsWith)
        {
            this.startsWith = startsWith;
        }

        public override bool IsMatchingProcess(Process process)
        {
            return process.ProcessName.StartsWith(startsWith);
        }
    }

}