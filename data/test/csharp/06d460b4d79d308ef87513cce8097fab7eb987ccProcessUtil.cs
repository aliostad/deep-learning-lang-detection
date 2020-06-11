using Common.Logging;
using System.Diagnostics;
using System.Threading;

namespace Org.Limingnihao.Api.Util
{
    public class ProcessUtil
    {
        private static readonly ILog logger = LogManager.GetLogger("ProcessUtil");

        public static Process StartProcess(string filePath)
        {
            return Process.Start(filePath);
        }

        public static Process StartProcess(string filePath, string processName)
        {
            string[] name = processName.Split('.');
            processName = name[0];
            Process[] processList = Process.GetProcesses();
            foreach (Process process in processList)
            {
                if (process.ProcessName.ToLower() == processName.ToLower())
                {
                    logger.Debug("StartProcess - 进程已存在 - filePath=" + filePath + ", processName=" + processName);
                    return process;
                }
            }
            logger.Debug("StartProcess - 启动进程 - filePath=" + filePath + ", processName=" + processName);
            return Process.Start(filePath);
        }

        public void KillProcess(Process process)
        {
            process.Kill();
            process.WaitForExit();
        }

        public static bool KillProcess(string processName)
        {
            string[] name = processName.Split('.');
            processName = name[0];
            Process[] processList = Process.GetProcesses();
            foreach (Process process in processList)
            {
                if (process.ProcessName.ToLower() == processName.ToLower())
                {
                    process.Kill();
                    process.WaitForExit();
                    return true;
                }
            }
            return false;
        }


    }
}
