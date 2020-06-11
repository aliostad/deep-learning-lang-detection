

using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;

namespace SebWindowsClient.ProcessUtils
{
  internal class ProcessWatchDog
  {
    private List<ProcessInfo> _processesToWatch = new List<ProcessInfo>();

    public void StartWatchDog()
    {
      if (this._processesToWatch.Count != 0)
        return;
      foreach (string prohibitedExecutable in SEBProcessHandler.ProhibitedExecutables)
      {
        ProcessInfo processInfo = new ProcessInfo(prohibitedExecutable);
        processInfo.Started += new ProcessInfo.StartedEventHandler(this.ProcessStarted);
        this._processesToWatch.Add(processInfo);
      }
    }

    private void ProcessStarted(object sender, EventArgs e)
    {
      string processName = ((ProcessInfo) sender).ProcessName;
      foreach (Process processToClose in ((IEnumerable<Process>) Process.GetProcesses()).Where<Process>((Func<Process, bool>) (p => processName.Contains(p.ProcessName))))
        SEBNotAllowedProcessController.CloseProcess(processToClose);
    }

    public void StopWatchDog()
    {
      foreach (ProcessInfo processInfo in this._processesToWatch)
        processInfo.Dispose();
      this._processesToWatch.Clear();
    }
  }
}
