using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace CKS.Dev.VisualStudio.SharePoint.Environment
{
    /// <summary>
    /// The process identifiers.
    /// </summary>
    internal class ProcessConstants
    {
        /// <summary>
        /// The IISWorkerProcess Process.
        /// </summary>
        public const string IISWorkerProcess = "w3wp.exe";

        /// <summary>
        /// The SPUCWorkerProcess Process.
        /// </summary>
        public const string SPUCWorkerProcess = "SPUCWorkerProcess.exe";

        /// <summary>
        /// The SPUCWorkerProcess Process Name.
        /// </summary>
        public const string SPUCWorkerProcessName = "SPUserCodeV4";

        /// <summary>
        /// The OWSTimerProcess Process.
        /// </summary>
        public const string OWSTimerProcess = "owstimer.exe";

        /// <summary>
        /// The OWSTimerProcess Process Name.
        /// </summary>
        public const string OWSTimerProcessName = "SPTimerV4";

        /// <summary>
        /// The VSSPHost4 Process.
        /// </summary>
        public const string VSSHost4Process = "vssphost4.exe";
    }
}
