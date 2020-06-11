using System;
using System.IO;
using System.Reflection;
using System.Security.AccessControl;
using System.Runtime.InteropServices;
using System.Text;
using System.ComponentModel;
using System.Diagnostics;
using System.Threading;

namespace Context
{
    internal static class ProcessUtils
    {
        public static string CurrentProcessName
        {
            get
            {
                return Process.GetCurrentProcess().ProcessName;
            }
        }

        public static void ShellExecute(string command, string verb)
        {
            Process process = new Process();
            process.StartInfo.FileName = command;
            process.StartInfo.Verb = verb;
            process.StartInfo.UseShellExecute = true;
            process.Start();
        }

        public static void ShellExecute(string command, string verb, string args)
        {
            Process process = new Process();
            process.StartInfo.FileName = command;
            if (verb != null)
            {
                process.StartInfo.Verb = verb;
            }
            if (args != null)
            {
                process.StartInfo.Arguments = args;
            }
            process.StartInfo.UseShellExecute = true;
            process.Start();
        }

        public static void StartProcessNoWindow(string fileName, string args)
        {
            Process process = new Process();
            process.StartInfo.FileName = fileName;
            process.StartInfo.Arguments = args;
            process.StartInfo.CreateNoWindow = true;
            process.StartInfo.UseShellExecute = false;
            process.Start();
        }

        public static void KillProcesses(string path)
        {
            string processName = Path.GetFileNameWithoutExtension(path);
            Process[] processes = Process.GetProcessesByName(processName);
            if (processes != null && processes.Length > 0)
            {
                foreach (Process process in processes)
                {
                    process.Kill();
                }
            }
        }

        public static void KillProcesses(string path, TimeSpan timeout)
        {
            string processName = Path.GetFileNameWithoutExtension(path);
            Process[] processes = Process.GetProcessesByName(processName);
            if (processes != null && processes.Length > 0)
            {
                foreach (Process process in processes)
                {
                    if (!process.WaitForExit((int)timeout.TotalMilliseconds))
                    {
                        process.Kill();
                    }
                }
            }
        }

        public static void WaitForProcessesExit(string path)
        {
            string processName = Path.GetFileNameWithoutExtension(path);
            Process[] processes = Process.GetProcessesByName(processName);
            if (processes != null && processes.Length > 0)
            {
                foreach (Process process in processes)
                {
                    process.WaitForExit();
                }
            }
        }

        public static void WaitForProcessesExit()
        {
            Process current = Process.GetCurrentProcess();
            string processName = current.ProcessName;
            for (int i = 0; i < 100; i++)
            {
                Process[] processes = Process.GetProcessesByName(processName);
                if (processes == null || processes.Length == 0)
                {
                    break;
                }

                if (processes.Length == 1 && processes[0].Id == current.Id)
                {
                    break;
                }

                foreach (Process process in processes)
                {
                    if (process.Id == current.Id)
                    {
                        continue;
                    }

                    try
                    {
                        process.WaitForExit();
                    }
                    catch
                    {
                        Thread.Sleep(1000);
                    }
                }
            }
        }

        public static bool ProcessStarted()
        {
            Process current = Process.GetCurrentProcess();
            string processName = current.ProcessName;
            Process[] processes = Process.GetProcessesByName(processName);
            if (processes != null && processes.Length > 0)
            {
                foreach (Process process in processes)
                {
                    if (process.Id == current.Id)
                    {
                        continue;
                    }

                    return true;
                }
            }

            return false;
        }

        public static void KillProcessesLike(string pattern)
        {
            int currentProcessId = Process.GetCurrentProcess().Id;
            Process[] processes = Process.GetProcesses();
            if (processes != null && processes.Length > 0)
            {
                foreach (Process process in processes)
                {
                    if (process.ProcessName.StartsWith(pattern, StringComparison.InvariantCultureIgnoreCase) && process.Id != currentProcessId)
                    {
                        process.Kill();
                    }
                }
            }
        }

        public static void KillProcessesLike(Predicate<string> predicate)
        {
            int currentProcessId = Process.GetCurrentProcess().Id;
            Process[] processes = Process.GetProcesses();
            if (processes != null && processes.Length > 0)
            {
                foreach (Process process in processes)
                {
                    if (predicate(process.ProcessName) && process.Id != currentProcessId)
                    {
                        process.Kill();
                    }
                }
            }
        }

        public static void KillProcesses()
        {
            string entryFile = Assembly.GetEntryAssembly().GetModules()[0].FullyQualifiedName;
            var processName = Path.GetFileNameWithoutExtension(entryFile);
            var current = Process.GetCurrentProcess();
            foreach (Process process in Process.GetProcessesByName(processName))
            {
                if (process.Id != current.Id)
                {
                    process.Kill();
                }
            }
        }
    }
}
