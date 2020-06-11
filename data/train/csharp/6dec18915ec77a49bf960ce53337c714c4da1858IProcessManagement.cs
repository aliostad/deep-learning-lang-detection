using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace WMIProvider
{
    interface IProcessManagement
    {
        /// <summary>
        /// Get status of Windows Process
        /// </summary>
        /// <param name="process"></param>
        /// <returns></returns>
        ProcessState GetProcessState(Process process);

        /// <summary>
        /// Create a Windows Process
        /// </summary>
        /// <param name="process"></param>
        /// <returns></returns>
        ProcessReturnCode CreateProcess(Process process);

        /// <summary>
        /// Terminate a Windows Process
        /// </summary>
        /// <param name="processName"></param>
        /// <returns></returns>
        ProcessReturnCode TerminateProcess(string processName);
    }
}
