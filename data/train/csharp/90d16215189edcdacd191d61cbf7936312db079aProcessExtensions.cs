using System;
using System.Diagnostics;
using System.Management;

namespace XMutator {
    public static class ProcessExtensions {
        private static string FindIndexedProcessName(int pid) {
            var processName = Process.GetProcessById(pid).ProcessName;
            var processesByName = Process.GetProcessesByName(processName);
            string processIndexdName = null;

            for (var index = 0; index < processesByName.Length; index++) {
                processIndexdName = index == 0 ? processName : processName + "#" + index;
                var processId = new PerformanceCounter("Process", "ID Process", processIndexdName);
                if ((int)processId.NextValue() == pid) {
                    return processIndexdName;
                }
            }

            return processIndexdName;
        }

        private static Process FindPidFromIndexedProcessName(string indexedProcessName) {
            var parentId = new PerformanceCounter("Process", "Creating Process ID",
                    indexedProcessName);
            return Process.GetProcessById((int)parentId.NextValue());
        }

        public static Process Parent(this Process process) {
            return FindPidFromIndexedProcessName(FindIndexedProcessName(process.Id));
        }

        public static void KillAllProcessesSpawnedBy(this Process process) {
            KillAllProcessesSpawnedBy((uint)process.Id);
        }

        public static void KillAllProcessesSpawnedBy(uint parentProcessId) {
            Debug.WriteLine("Finding processes spawned by process with Id [" + parentProcessId + "]");

            // NOTE: Process Ids are reused!
            var searcher = new ManagementObjectSearcher(
                    "SELECT * " +
                    "FROM Win32_Process " +
                    "WHERE ParentProcessId=" + parentProcessId);
            var collection = searcher.Get();
            if (collection.Count <= 0) {
                return;
            }
            Debug.WriteLine("Killing [" + collection.Count
                            + "] processes spawned by process with Id [" + parentProcessId + "]");
            foreach (var item in collection) {
                var childProcessId = (uint)item["ProcessId"];
                if ((int)childProcessId == Process.GetCurrentProcess().Id) {
                    continue;
                }
                KillAllProcessesSpawnedBy(childProcessId);

                var childProcess = Process.GetProcessById((int)childProcessId);
                Debug.WriteLine("Killing child process [" + childProcess.ProcessName + "] with Id ["
                                + childProcessId + "]");
                childProcess.Kill();
            }
        }
    }
}