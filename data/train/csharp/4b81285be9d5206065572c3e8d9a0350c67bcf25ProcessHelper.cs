using System.Diagnostics;
using Assassin.Sociaty.Services;

namespace Assassin.Sociaty.Helpers
{
    public static class ProcessHelper
    {
        public static void RunProcess(string fullname, string args = null)
        {
            var psi = new ProcessStartInfo(fullname, args);
            var process = new Process()
            {
                StartInfo = psi,
            };

            //MARK: Should do somthing else before start?
            process.Start();
        }

        public static void RunProcess(Process process)
        {
            process.Start();
        }

        public static void RunProcess(ProcessStartInfo processStartInfo)
        {
            Process.Start(processStartInfo);
        }
    }
}