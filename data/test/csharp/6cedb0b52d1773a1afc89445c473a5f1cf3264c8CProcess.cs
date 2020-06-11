using System.Diagnostics;

namespace UTLBASEFORM
{
    public class CProcess
    {
        public CProcess()
        { 
        }
        public bool FindAndKillProcess(string name)
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
        public static void FindAndKillAllProcess(string name)
        {
            foreach (Process clsProcess in Process.GetProcesses())
            {
                if (clsProcess.ProcessName.StartsWith(name))
                {
                    clsProcess.Kill();
                }
            }
        }
    }
}
