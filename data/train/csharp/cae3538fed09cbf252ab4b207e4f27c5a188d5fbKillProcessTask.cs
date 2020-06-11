using System;
using System.Diagnostics;

namespace Flubu.Tasks.Processes
{
    /// <summary>
    /// Kills a specified process.
    /// </summary>
    public class KillProcessTask : TaskBase
    {
        /// <summary>
        /// Gets the task description.
        /// </summary>
        /// <value>The task description.</value>
        public override string TaskDescription
        {
            get
            {
                return String.Format (
                    System.Globalization.CultureInfo.InvariantCulture,
                    "Kill process '{0}'", 
                    processName);
            }
        }

        /// <summary>
        /// Initializes a new instance of the <see cref="KillProcessTask"/> class using a specified process name.
        /// </summary>
        /// <param name="processName">Name of the process to be killed.</param>
        public KillProcessTask (string processName)
        {
            this.processName = processName;
        }

        public static void Execute (IScriptExecutionEnvironment environment, string processName)
        {
            KillProcessTask task = new KillProcessTask (processName);
            task.Execute (environment);
        }

        protected override void DoExecute (IScriptExecutionEnvironment environment)
        {
            Process[] processByName = Process.GetProcessesByName (processName);
            foreach (Process process in processByName)
            {
                environment.LogMessage("Killing process '{0}'", process.ProcessName);
                process.Kill ();
            }
        }

        private string processName;
    }
}
