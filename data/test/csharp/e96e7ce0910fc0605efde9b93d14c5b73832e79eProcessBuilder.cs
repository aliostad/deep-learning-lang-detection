using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Diagnostics;
using System.Threading.Tasks;

namespace AdbAssistant
{
    internal class ProcessBuilder
    {

        public static string ProcessNew(string processName, string processArgument, string activeDevice)
        {
            var processArgumentWithDevice = new StringBuilder();
            processArgumentWithDevice.Append("/c adb -s ");
            processArgumentWithDevice.Append(activeDevice);
            processArgumentWithDevice.Append(" ");
            processArgumentWithDevice.Append(processArgument);

            var processInfo = new ProcessStartInfo(processName, processArgumentWithDevice.ToString());
            processInfo.RedirectStandardOutput = true;
            processInfo.UseShellExecute = false;
            processInfo.CreateNoWindow = true;
            var process = new Process();
            process.StartInfo = processInfo;
            process.Start();
            string result = process.StandardOutput.ReadToEnd();
            process.WaitForExit();
            processArgumentWithDevice = null;
            return result;
        }

        public static string ProcessNew(string processArgument)
        {
            var processInfo = new ProcessStartInfo("cmd.exe", processArgument);
            processInfo.RedirectStandardOutput = true;
            processInfo.UseShellExecute = false;
            processInfo.CreateNoWindow = true;
            var process = new Process();
            process.StartInfo = processInfo;
            process.Start();
            string result = process.StandardOutput.ReadToEnd();
            process.WaitForExit();
            return result;
        }

        public static void ProcessNew(string processArgument, string activeDevice)
        {
            var processArgumentWithDevice = new StringBuilder();
            processArgumentWithDevice.Append("/c adb -s ");
            processArgumentWithDevice.Append(activeDevice);
            processArgumentWithDevice.Append(" ");
            processArgumentWithDevice.Append(processArgument);

            var processInfo = new ProcessStartInfo("cmd.exe", processArgumentWithDevice.ToString());
            processInfo.RedirectStandardOutput = true;
            processInfo.UseShellExecute = false;
            processInfo.CreateNoWindow = true;
            var process = new Process();
            process.StartInfo = processInfo;
            process.Start();
            string result = process.StandardOutput.ReadToEnd();
            process.WaitForExit();
        }

    }
}
