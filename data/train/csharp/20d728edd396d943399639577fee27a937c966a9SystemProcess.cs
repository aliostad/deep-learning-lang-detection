using System.Diagnostics;

namespace Oleg.Kleyman.Core
{
    /// <summary>
    ///     Represents a system process.
    /// </summary>
    public class SystemProcess : IProcess
    {
        internal SystemProcess(Process systemProcess)
        {
            Process = systemProcess;
        }

        #region Implementation of IProcess

        /// <summary>
        ///     Gets whether the process has exited.
        /// </summary>
        public bool HasExited
        {
            get { return Process.HasExited; }
        }

        /// <summary>
        ///     Blocks the current thread until the process exits.
        /// </summary>
        public void WaitForExit()
        {
            Process.WaitForExit();
        }

        /// <summary>
        ///     Gets or sets the priority of the process.
        /// </summary>
        public ProcessPriorityClass PriorityClass
        {
            get { return Process.PriorityClass; }
            set { Process.PriorityClass = value; }
        }

        /// <summary>
        ///     Ends the process forcefully.
        /// </summary>
        public void Kill()
        {
            Process.Kill();
        }

        #endregion

        protected Process Process { get; private set; }
    }
}