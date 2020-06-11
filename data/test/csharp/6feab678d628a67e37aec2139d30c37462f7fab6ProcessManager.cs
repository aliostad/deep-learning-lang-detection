using System;
using System.Diagnostics;

namespace ProcessScheduler
{
    public static class ProcessManager
    {
        public static void SuspendProcess(Process process)
        {
            if ((process == null) || (process.HasExited)) return;
            ProcessThreadCollection collection = process.Threads;
            foreach (ProcessThread thread in collection)
                ThreadManager.SuspendThread(thread);
        }

        public static void ResumeProcess(Process process)
        {
            if ((process == null) || (process.HasExited)) return;
            ProcessThreadCollection collection = process.Threads;
            foreach (ProcessThread thread in collection)
                ThreadManager.ResumeThread(thread);
        }

        public static void TerminateProcess(Process process)
        {
            if ((process == null) || (process.HasExited)) return;
            ProcessThreadCollection collection = process.Threads;
            foreach (ProcessThread thread in collection)
                ThreadManager.suspendedThreadsIdList.Remove(thread.Id);
            process.Kill();
        }
    }
}
