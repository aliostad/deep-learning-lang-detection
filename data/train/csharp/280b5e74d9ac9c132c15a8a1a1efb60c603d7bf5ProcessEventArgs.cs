namespace GR.Automation.Services.ReportQueue.Events
{
    using System;

    /// <summary>
    /// Args for ProcessEvent
    /// </summary>
    public class ProcessEventArgs : EventArgs
    {
        private IHostedProcess _Process;

        /// <summary>
        /// Initializes a new instance of the <see cref="ProcessEventArgs"/> class.
        /// </summary>
        /// <param name="process">The process.</param>
        public ProcessEventArgs(IHostedProcess process)
        {
            this._Process = process;
        }

        /// <summary>
        /// Gets the process.
        /// </summary>
        /// <value>The process.</value>
        public IHostedProcess Process
        {
            get
            {
                return this._Process;
            }
        }
    }
}
