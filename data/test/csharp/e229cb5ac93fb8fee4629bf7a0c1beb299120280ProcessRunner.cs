using System;
using System.Diagnostics;

namespace BuildDataDriver.tools
{
    class ProcessRunner
    {
        /// <summary>
        /// Runs a process with the process setup in a manner that will be ideal for running from a service
        /// </summary>
        /// <param name="processExe">string - executable to run</param>
        /// <param name="processCommandLine">string - the command line arguments to the executable</param>
        /// <returns>Process</returns>
        public static Process RunProcess(string processExe, string processCommandLine)
        {
            Process process = new Process
            {
                StartInfo =
                {
                    FileName = processExe,
                    Arguments = processCommandLine,
                    WindowStyle = ProcessWindowStyle.Hidden,
                    UseShellExecute = false,
                    CreateNoWindow = true,
                    ErrorDialog = false
                }
            };
            process.Start();
            process.WaitForExit();
            return process;
        }
    }
}