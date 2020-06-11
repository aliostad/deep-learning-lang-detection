namespace Omego.SimpleFtp
{
    using System;
    using System.Diagnostics;

    /// <summary>
    ///     Represents a system process.
    /// </summary>
    public class SystemProcess : ISystemProcess
    {
        private readonly Process process;

        /// <summary>
        ///     Initializes a new instance of the <see cref="SystemProcess" /> class.
        /// </summary>
        /// <param name="process">The <see cref="Process" /> to use for operations.</param>
        public SystemProcess(Process process)
        {
            if (process == null) throw new ArgumentNullException(nameof(process));

            this.process = process;
        }

        /// <summary>
        ///     Kills the <see cref="ISystemProcess" />.
        /// </summary>
        public void Kill()
        {
            process.Kill();
            process.WaitForExit();
        }

        /// <summary>
        ///     Gets <see cref="ISystemProcess.HasExited" />.
        /// </summary>
        /// <value>Whether or not the process has exited.</value>
        public bool HasExited => process.HasExited;
    }
}