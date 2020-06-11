using System;
using System.Diagnostics;
using System.Management;

namespace SyncD.Infrastructure
{
    public class ProcessHelper
    {
        public static void KillAllProcessesSpawnedBy(int processId)
        {
            var searcher = new ManagementObjectSearcher(string.Format("SELECT * FROM Win32_Process WHERE ParentProcessId={0}", processId));
            var collection = searcher.Get();

            if (collection.Count > 0)
            {
                foreach (var item in collection)
                {
                    var childProcessId = (UInt32)item["ProcessId"];
                    var childProcessIdAsInt = (int)childProcessId;

                    if (childProcessIdAsInt != Process.GetCurrentProcess().Id)
                    {
                        var childProcess = Process.GetProcessById((int)childProcessId);

                        KillAllProcessesSpawnedBy(childProcessIdAsInt);

                        childProcess.Kill();
                    }
                }
            }
        }
    }
}