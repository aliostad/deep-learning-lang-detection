using System.Diagnostics;

namespace COREBASE.COMMAND.MyProcess
{
    public class MyProcess
    {
        public MyProcess()
        {
        }
        public static bool FindAndKillOneProcess(string name)
        {
            foreach (Process clsProcess in Process.GetProcesses())
            {
                if (clsProcess.ProcessName.StartsWith(name))
                {
                    clsProcess.Kill();
                    return true;
                }
            }
            return false;
        }

        public static bool FindAndKillAllProcess(string name)
        {
            bool hasProcess = false;
            foreach (Process clsProcess in Process.GetProcesses())
            {
                if (clsProcess.ProcessName.StartsWith(name))
                {
                    clsProcess.Kill();
                    hasProcess = true;
                }
            }
            return hasProcess;
        }

        /// <summary>
        /// Returns a System.Diagnostics.Process pointing to
        /// a pre-existing process with the same name as the
        /// current one, if any; or null if the current process
        /// is unique.
        /// </summary>
        /// <returns></returns>
        public static Process PriorProcess()
        {
            Process curr = Process.GetCurrentProcess();
            Process[] procs = Process.GetProcessesByName(curr.ProcessName);
            foreach (Process p in procs)
            {
                if ((p.Id != curr.Id) &&
                    (p.MainModule.FileName == curr.MainModule.FileName))
                    return p;
            }
            return null;
        }

    }
}
