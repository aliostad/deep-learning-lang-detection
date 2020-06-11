namespace ProcessKiller.Logic
{
    using System.Collections.Generic;
    using System.Diagnostics;
    using System.Linq;

    using global::ProcessKiller.Model;

    public class ProcessManager
    {
        public List<ProcessModel> GetRunningProcesses()
        {
            return Process.GetProcesses()
                          .Select(p => new ProcessModel
                                           {
                                               Name = p.ProcessName.ToLower(),
                                               Pid = p.Id
                                           })
                          .ToList();
        }

        public void Kill(ProcessModel process)
        {
            var processToKill = Process.GetProcessById(process.Pid);

            if (!processToKill.HasExited)
            {
                processToKill.Kill();
            }
        }
    }
}