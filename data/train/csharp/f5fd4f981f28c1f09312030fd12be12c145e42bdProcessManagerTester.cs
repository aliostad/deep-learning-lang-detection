using System;
using System.Diagnostics;
using System.Threading;
using ProcessMonitor.Logging;
using ProcessMonitoring;

namespace ProcessMonitorWpf
{
    /// <summary>
    /// An utility class used for testing ProcessManager.
    /// </summary>
    public class ProcessManagerTester
    {
        private const int DelayBetweenTestStepsInMilliseconds = 3000;
        private ProcessManager _processManager;
        private LogControl _logControl;
        private string _processNamePrefix;
        private bool _wasRestarted;

        public ProcessManagerTester(string processNamePrefix, LogControl logControl)
        {
            _processManager = new ProcessManager();
            _processNamePrefix = processNamePrefix;
            _logControl = logControl;
        }

        public void RunTest(Process process)
        {
            if (process != null
                && !string.IsNullOrEmpty(process.ProcessName)
                && process.ProcessName.StartsWith(_processNamePrefix))
            {
                string processDetails = "[" + process.Id + " " + process.ProcessName + "]";
                bool runSuspendAndResumeTest = false;

                if (!_wasRestarted)
                {
                    LogMessage("RunTest: Started testing process manager with process " + processDetails);
                    LogMessage(ProcessUtils.ProcessDetailsToString(process));

                    if (process.StartInfo != null && !string.IsNullOrEmpty(process.StartInfo.FileName))
                    {
                        LogMessage("RunTest: Killing process " + processDetails);

                        try
                        {
                            _processManager.KillProcess(process);
                            LogMessage("RunTest: Process " + processDetails + " killed");

                            Thread.Sleep(DelayBetweenTestStepsInMilliseconds);

                            LogMessage("RunTest: Restarting process " + processDetails);
                            _processManager.RestartProcess(process);
                            LogMessage("RunTest: Process " + processDetails + " restarted");
                        }
                        catch (Exception e)
                        {
                            LogMessage("RunTest: Failed to kill/restart process "
                                + processDetails + ": " + e.Message);
                        }
                    }
                    else
                    {
                        LogMessage("RunTest: Cannot test killing/restarting process "
                            + processDetails + " - the process could not be restarted since the file name is missing from the start info");
                        runSuspendAndResumeTest = true;
                    }
                }
                else
                {
                    _wasRestarted = false;
                    runSuspendAndResumeTest = true;
                }

                if (runSuspendAndResumeTest)
                {
                    RunSuspendAndResumeTest(process, processDetails);
                    Thread.Sleep(DelayBetweenTestStepsInMilliseconds);
                    LogMessage("RunTest: Done testing with process " + processDetails);
                }
            }
        }

        private void RunSuspendAndResumeTest(Process process, string processDetails)
        {
            LogMessage("RunTest: Suspending process " + processDetails);

            try
            {
                if (_processManager.SuspendProcess(process))
                {
                    LogMessage("RunTest: Process " + processDetails + " suspended");

                    Thread.Sleep(DelayBetweenTestStepsInMilliseconds);

                    LogMessage("RunTest: Resuming process " + processDetails);

                    if (_processManager.ResumeProcess(process))
                    {
                        LogMessage("RunTest: Process " + processDetails + " resumed");
                    }
                    else
                    {
                        LogMessage("RunTest: Failed to resume process " + processDetails);
                    }
                }
                else
                {
                    LogMessage("RunTest: Failed to suspend process " + processDetails);
                }
            }
            catch (Exception e)
            {
                LogMessage("RunTest: Failed to suspend/resume process " + processDetails + ": " + e.Message);
            }
        }

        private void LogMessage(string message)
        {
            Debug.WriteLine(DateTime.Now.ToLongTimeString() + " " + message);
            
            if (_logControl != null)
            {
                _logControl.AddLogMessage(message);
            }
        }
    }
}
