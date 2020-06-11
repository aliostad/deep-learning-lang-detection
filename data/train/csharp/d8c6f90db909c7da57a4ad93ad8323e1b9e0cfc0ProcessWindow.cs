using System;
using System.Diagnostics;

namespace WinApiRemoteLib
{
    public class ProcessWindow
    {
        public string ProcessName { get; set; }
        public string Title { get; set; }
        public IntPtr Handle { get; set; }

        public ProcessWindow()
        {
            
        }

        public ProcessWindow(Process process)
        {
            ProcessName = process.ProcessName;
            Title = process.MainWindowTitle;
            Handle = process.MainWindowHandle;
        }
    }
}