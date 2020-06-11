using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Diagnostics;

namespace com.gs.cmd
{
    class ProcessCreator
    {
        private static ProcessCreator instance;

        private int exitCode;
        private ProcessStartInfo processInfo;
        

        private ProcessCreator() 
        {
            processInfo = new ProcessStartInfo("cmd.exe");
            processInfo.CreateNoWindow = true;
            processInfo.UseShellExecute = false;
        }

        public static ProcessCreator getInstance()
        {
            if (null == instance)
            {
                instance = new ProcessCreator();
            }
            return instance;
        }

        public Process createNewProcess(bool createNewWindow)
        {
            Process process = Process.Start(processInfo);
            return process;
        }
    }
}
