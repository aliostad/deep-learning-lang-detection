using System;
using System.Diagnostics;

namespace Codebot.Runtime
{
    public static class Program
    {
        public static bool IsLinux
        {
            get
            {
                int p = (int) Environment.OSVersion.Platform;
                return (p == 4) || (p == 6) || (p == 128);
            }
        }

        public static string Execute(string program, params string[] args)
        {
            Process process = new Process();
            process.StartInfo.FileName = program;
            process.StartInfo.Arguments = args.Quote();
            process.StartInfo.UseShellExecute = false;
            process.StartInfo.RedirectStandardOutput = true;
            process.Start();    
            process.WaitForExit();
            string s = process.StandardOutput.ReadToEnd();
            process.Close();
            return s;
        }


        public static string ExecuteCommand(string command)
        {
            if (IsLinux)
                return "The program cmd.exe does not run on Linux";
            ProcessStartInfo processInfo;
            Process process;
            processInfo = new ProcessStartInfo("cmd.exe", "/c " + command);
            processInfo.CreateNoWindow = true;
            processInfo.UseShellExecute = false;
            processInfo.RedirectStandardOutput = true;
            process = Process.Start(processInfo);
            process.WaitForExit();
            string s = process.StandardOutput.ReadToEnd();
            process.Close();
            return s;
        }

        public static string ExecuteScript(string script)
        {
            ProcessStartInfo processInfo;
            Process process;
            if (IsLinux)
                processInfo = new ProcessStartInfo("bash", script);
            else
                processInfo = new ProcessStartInfo("cmd.exe", "/c " + script);
            processInfo.CreateNoWindow = true;
            processInfo.UseShellExecute = false;
            processInfo.RedirectStandardOutput = true;
            process = Process.Start(processInfo);
            process.WaitForExit();
            string s = process.StandardOutput.ReadToEnd();
            process.Close();
            return s;
        }
    }
}

