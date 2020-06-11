using System;
using System.Diagnostics;

namespace ProcessWatcher
{
    class ProcessWatch
    {
        public readonly Process process;
        public ProcessWatch(Process process)
        {
            this.process = process;
        }

        public override string ToString()
        {
            if (process.MainWindowHandle == IntPtr.Zero)
            {
                return process.ProcessName;
            }
            else
            {
                return process.ProcessName + " : " + process.MainWindowTitle;
            }
        }
        public bool HasExited
        {
            get { return process.HasExited; }
        }
    }
}
