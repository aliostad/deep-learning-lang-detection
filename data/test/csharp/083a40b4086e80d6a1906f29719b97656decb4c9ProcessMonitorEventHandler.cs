using ProcessMonitoring;
using System.Diagnostics;

namespace ProcessMonitorConsole
{
    /// <summary>
    /// Handles the events fired by PollingProcessMonitor.
    /// </summary>
    public class ProcessMonitorEventHandler
    {
        private PollingProcessMonitor _processMonitor;

        public ProcessMonitorEventHandler(PollingProcessMonitor processMonitor)
        {
            _processMonitor = processMonitor;
            _processMonitor.ProcessListChanged += OnProcessListChanged;
            _processMonitor.ForegroundProcessChanged += OnForegroundProcessChanged;
        }

        private string ProcessNameAndIdAsString(Process process)
        {
            return process.ProcessName + " (" + process.Id + ")";
        }

        private void OnForegroundProcessChanged(object sender, ForegroundProcessChangedEventArgs e)
        {
            if (e.NewForegroundProcess != null && e.PreviousForegroundProcess != null)
            {
                Logger.Log("Foreground process changed from "
                    + ProcessNameAndIdAsString(e.PreviousForegroundProcess)
                    + " to " + ProcessNameAndIdAsString(e.NewForegroundProcess));
            }
            else if (e.NewForegroundProcess == null && e.PreviousForegroundProcess != null)
            {
                Logger.Log("No processes on foreground, previous was "
                    + ProcessNameAndIdAsString(e.PreviousForegroundProcess));
            }
            else if (e.NewForegroundProcess != null && e.PreviousForegroundProcess == null)
            {
                Logger.Log("New foreground process: "
                    + ProcessNameAndIdAsString(e.NewForegroundProcess));
            }
        }

        private void OnProcessListChanged(object sender, ProcessListChangedEventArgs e)
        {
            if (e.PreviousProcessCount != 0)
            {
                Logger.Log("Process count changed from " + e.PreviousProcessCount + " to " + e.NewProcessCount);

                if (e.AddedProcesses.Count > 0)
                {
                    Logger.Log("Added processes:");

                    for (int i = 0; i < e.AddedProcesses.Count; ++i)
                    {
                        Logger.Log(" - " + ProcessNameAndIdAsString(e.AddedProcesses[i]));
                    }
                }

                if (e.RemovedProcesses.Count > 0)
                {
                    Logger.Log("Removed processes:");

                    for (int i = 0; i < e.RemovedProcesses.Count; ++i)
                    {
                        Logger.Log(" - " + ProcessNameAndIdAsString(e.RemovedProcesses[i]));
                    }
                }
            }
        }
    }
}
