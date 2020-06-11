using System;
using System.Diagnostics;
using System.Linq;

namespace Amigula.Helpers
{
    public class AppHelper
    {
        /// <summary>
        ///     Make sure there is no other instance of the application running
        /// </summary>
        /// <returns></returns>
        private static bool EnsureSingleInstance()
        {
            Process currentProcess = Process.GetCurrentProcess();
            Process runningProcess = (from process in Process.GetProcesses()
                where
                    process.Id != currentProcess.Id &&
                    process.ProcessName.Equals(
                        currentProcess.ProcessName,
                        StringComparison.Ordinal)
                select process).FirstOrDefault();

            if (runningProcess == null) return true;

            ShowMainWindow(runningProcess);
            BringMainWindowToForeground(runningProcess);
            return false;
        }

        private static void ShowMainWindow(Process runningProcess)
        {
            const int swShowmaximized = 3;
            SafeNativeMethods.ShowWindow(runningProcess.MainWindowHandle, swShowmaximized);
        }

        /// <summary>
        /// Brings the main window to foreground.
        /// </summary>
        /// <param name="runningProcess">The running process.</param>
        private static void BringMainWindowToForeground(Process runningProcess)
        {
            SafeNativeMethods.SetForegroundWindow(runningProcess.MainWindowHandle);
        }
    }
}