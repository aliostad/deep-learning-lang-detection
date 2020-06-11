using System;
using System.Diagnostics;
using System.Linq;

namespace NVIDIASurroundToggle.InterProcess
{
    internal static class Helper
    {
        public static bool QueryStatus(InstanceStatus status)
        {
            var thisProcess = Process.GetCurrentProcess();
            return Utility.DoTimeout(
                () =>
                {
                    try
                    {
                        return
                            Process.GetProcessesByName(thisProcess.ProcessName)
                                .Where(process => process.Id != thisProcess.Id)
                                .Select(process => new Client(process))
                                .Any(client => client.Status == status);
                    }
                    catch (Exception)
                    {
                        return false;
                    }
                },
                500);
        }

        public static bool IsAnyProgramActive()
        {
            var thisProcess = Process.GetCurrentProcess();
            return Utility.DoTimeout(
                () =>
                {
                    try
                    {
                        return
                            Process.GetProcessesByName(thisProcess.ProcessName)
                                .Any(process => process.Id != thisProcess.Id);
                    }
                    catch (Exception)
                    {
                        return false;
                    }
                },
                500);
        }
    }
}