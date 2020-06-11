using System.Diagnostics;
using NAnt.Core;
using NAnt.Core.Attributes;

namespace Bricks.Nant
{
    [TaskName("kill")]
    public class KillTask : Task
    {
        private string processName;

        [TaskAttribute("process")]
        public virtual string ProcessName
        {
            get { return processName; }
            set { processName = value; }
        }

        protected override void ExecuteTask()
        {
            Process[] processes = Process.GetProcessesByName(processName);
            foreach (Process process in processes)
            {
                process.Kill();
            }
        }
    }
}