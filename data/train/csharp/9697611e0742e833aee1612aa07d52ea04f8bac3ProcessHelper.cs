using System.Diagnostics;
using Aroochi.Services.Maker.Models;

namespace Aroochi.Services.Maker.Helpers
{
    public static class ProcessHelper
    {
        public static Process Execute(string command, bool waitForExit = true)
        {
            Process process = new Process();
            ProcessStartInfo processInfo = new ProcessStartInfo("cmd", $"/c {command}");
            processInfo.RedirectStandardOutput = true;
            processInfo.RedirectStandardError = true;
            processInfo.RedirectStandardInput = true;
            processInfo.UseShellExecute = false;
            processInfo.CreateNoWindow = true;
            process.StartInfo = processInfo;
            process.Start();
            if (waitForExit)
                process.WaitForExit();
            return process;
        }

        public static void FillStepInfo(MakeStep step, Process process)
        {
            string processLog = process.StandardOutput.ReadToEnd();
            if (string.IsNullOrEmpty(processLog))//there is an error for Siging the apk
            {
                step.Status = false;
                processLog = process.StandardError.ReadToEnd();
            }
            step.Message = processLog;
            step.ExecutionTime = process.TotalProcessorTime;
            step.StartTime = process.StartTime;
            step.EndTime = process.ExitTime;
        }
    }
}