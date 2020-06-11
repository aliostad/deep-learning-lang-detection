#if UNIX
#pragma warning disable CS1591
namespace RC.Framework.Native.Unix.Diagnostics
{
    using System;
    using System.Collections.Generic;
    using System.Diagnostics;
    using System.IO;
    using System.Linq;
    public sealed class nixProcess
    {
        public nixProcess(Process process)
        {
            if (process == null)
                throw new ArgumentNullException(nameof(process));
            SetProcessInfo(process);
        }
        public int Id                       { get; private set; }
        public string ProcessName           { get; private set; }
        public nixProcessState ProcessState { get; private set; }
        public string CommandLine           { get; private set; }
        public Process ProcessObject        { get; private set; }


        public static nixProcess Start(ProcessStartInfo startInfo)
        {
            var process = Process.Start(startInfo);

            return new nixProcess(process);
        }
        public static nixProcess Start(string fileName, string arguments = null)
        {
            var process = (arguments != null)
                ? Process.Start(fileName, arguments)
                : Process.Start(fileName);

            return new nixProcess(process);
        }
        public void Kill() => ProcessObject.Kill();

        public static nixProcess GetCurrentProcess()
        {
            var process = Process.GetCurrentProcess();
            return new nixProcess(process);
        }

        public static nixProcess GetProcessById(int processId)
        {
            var process = Process.GetProcessById(processId);
            return new nixProcess(process);
        }

        public static IEnumerable<nixProcess> GetProcessesByName(string processName) => GetProcesses().Where(p => p.ProcessName == processName);

        public static IEnumerable<nixProcess> GetProcesses()
        {
            foreach (var processDirectory in Directory.GetDirectories("/proc"))
            {
                int processId;
                var processDirectoryName = Path.GetFileName(processDirectory);

                if (!int.TryParse(processDirectoryName, out processId)) continue;
                Process process = null;

                try
                {
                    process = Process.GetProcessById(processId);
                }
                catch
                {
                }

                if (process != null)
                {
                    yield return new nixProcess(process);
                }
            }
        }


        private void SetProcessInfo(Process process)
        {
            var processStatus = GetProcessStatus(process.Id);
            var processCommandLine = GetProcessCommandLine(process.Id);

            Id = process.Id;
            ProcessName = processStatus.Name;
            ProcessState = processStatus.State;
            CommandLine = processCommandLine;
            ProcessObject = process;
        }

        private static LinuxProcessStatus GetProcessStatus(int processId)
        {
            var processStatusFile = $"/proc/{processId}/stat";
            try
            {
                if (File.Exists(processStatusFile))
                {
                    using (var reader = File.OpenText(processStatusFile))
                    {
                        var statusText = reader.ReadToEnd();
                        return ParseProcessStatus(statusText);
                    }
                }
            }
            catch
            {
            }
            return default(LinuxProcessStatus);
        }

        private static string GetProcessCommandLine(int processId)
        {
            var processCommandLineFile = $"/proc/{processId}/cmdline";
            try
            {
                if (File.Exists(processCommandLineFile))
                {
                    using (var reader = File.OpenText(processCommandLineFile))
                    {
                        var commandLineText = reader.ReadToEnd();
                        return ParseCommandLine(commandLineText);
                    }
                }
            }
            catch
            {
            }

            return string.Empty;
        }

        private static LinuxProcessStatus ParseProcessStatus(string statusText)
        {
            var result = new LinuxProcessStatus { State = nixProcessState.Unknown };

            if (string.IsNullOrEmpty(statusText)) return result;
            var items = statusText.Split(new[] { ' ' }, StringSplitOptions.None);

            if (items.Length <= 0) return result;
            int.TryParse(items[0], out result.Id);

            if (items.Length <= 1) return result;
            result.Name = items[1].TrimStart('(').TrimEnd(')');

            if (items.Length <= 2 || items[2].Length <= 0) return result;
            if (char.ToUpper(items[2][0]) == 'R')       result.State = nixProcessState.Running;
            else if (char.ToUpper(items[2][0]) == 'S')  result.State = nixProcessState.InterruptableWait;
            else if (char.ToUpper(items[2][0]) == 'D')  result.State = nixProcessState.UninterruptableDiskWait;
            else if (char.ToUpper(items[2][0]) == 'Z')  result.State = nixProcessState.Zombie;
            else if (char.ToUpper(items[2][0]) == 'T')  result.State = nixProcessState.Traced;
            else if (char.ToUpper(items[2][0]) == 'W')  result.State = nixProcessState.Paging;
            return result;
        }
        private static string ParseCommandLine(string commandLineText)
        {
            if (string.IsNullOrEmpty(commandLineText)) return string.Empty;
            var arguments = commandLineText.Split(new[] { '\0' }, StringSplitOptions.RemoveEmptyEntries);
            return string.Join(" ", arguments);
        }
        internal struct LinuxProcessStatus
        {
            public int Id;
            public string Name;
            public nixProcessState State;
        }
    }
}
#endif