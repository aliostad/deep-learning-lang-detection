﻿using System;
using System.Diagnostics;
using System.Runtime.InteropServices;

namespace Shiny
{
    /// <summary>
    /// A utility class to determine a process parent.
    /// </summary>
    [StructLayout(LayoutKind.Sequential)]
    public struct ParentProcessUtilities
    {
        // These members must match PROCESS_BASIC_INFORMATION
        internal IntPtr Reserved1;
        internal IntPtr PebBaseAddress;
        internal IntPtr Reserved2_0;
        internal IntPtr Reserved2_1;
        internal IntPtr UniqueProcessId;
        internal IntPtr InheritedFromUniqueProcessId;

        [DllImport("ntdll.dll")]
        private static extern int NtQueryInformationProcess(IntPtr processHandle, int processInformationClass, ref ParentProcessUtilities processInformation, int processInformationLength, out int returnLength);

        /// <summary>
        /// Gets the parent process of the current process.
        /// </summary>
        /// <returns>An instance of the Process class.</returns>
        public static Process GetParentProcess()
        {
            return GetParentProcess(Process.GetCurrentProcess().Handle);
        }

        /// <summary>
        /// Gets the parent process of specified process.
        /// </summary>
        /// <param name="id">The process id.</param>
        /// <returns>An instance of the Process class.</returns>
        public static Process GetParentProcess(int id)
        {
            var process = Process.GetProcessById(id);
            return GetParentProcess(process.Handle);
        }

        /// <summary>
        /// Gets the parent process of a specified process.
        /// </summary>
        /// <param name="handle">The process handle.</param>
        /// <returns>An instance of the Process class or null if an error occurred.</returns>
        public static Process GetParentProcess(IntPtr handle)
        {
            var pbi = new ParentProcessUtilities();
            int returnLength;
            var status = NtQueryInformationProcess(handle, 0, ref pbi, Marshal.SizeOf(pbi), out returnLength);
            if (status != 0)
                return null;

            try
            {
                return Process.GetProcessById(pbi.InheritedFromUniqueProcessId.ToInt32());
            }
            catch (ArgumentException)
            {
                // not found
                return null;
            }
        }
    }

    // If windows drops support for the internal stuff I used for performance, use this:
//    public static class ProcessExtensions {
//        private static string FindIndexedProcessName(int pid) {
//            var processName = Process.GetProcessById(pid).ProcessName;
//            var processesByName = Process.GetProcessesByName(processName);
//            string processIndexdName = null;
//
//            for (var index = 0; index < processesByName.Length; index++) {
//                processIndexdName = index == 0 ? processName : processName + "#" + index;
//                var processId = new PerformanceCounter("Process", "ID Process", processIndexdName);
//                if ((int) processId.NextValue() == pid) {
//                    return processIndexdName;
//                }
//            }
//
//            return processIndexdName;
//        }
//
//        private static Process FindPidFromIndexedProcessName(string indexedProcessName) {
//            var parentId = new PerformanceCounter("Process", "Creating Process ID", indexedProcessName);
//            return Process.GetProcessById((int) parentId.NextValue());
//        }
//
//        public static Process Parent(this Process process) {
//            return FindPidFromIndexedProcessName(FindIndexedProcessName(process.Id));
//        }
//    }
}