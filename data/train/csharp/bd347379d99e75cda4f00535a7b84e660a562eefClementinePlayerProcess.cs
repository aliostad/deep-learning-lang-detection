using System.Diagnostics;

namespace Sciendo.Music.DataProviders
{
    public class ClementinePlayerProcess:IPlayerProcess
    {
        public bool AddSongToQueue(string filePath, string withProcess)
        {
            Process playerProcess;
            if(!IsProcessOpen(withProcess, out playerProcess))
            {
                return false;
            }
            playerProcess.StartInfo = new ProcessStartInfo(playerProcess.MainModule.FileName, @"-a """ + filePath.Replace(@"file:///","") +@"""");
            playerProcess.Start();
            return !playerProcess.HasExited;
        }

        private bool IsProcessOpen(string name, out Process playerProcess)
        {
            foreach (Process clsProcess in Process.GetProcesses())
            {
                if (clsProcess.ProcessName==name)
                {
                    playerProcess = clsProcess;
                    return true;
                }
            }
            playerProcess = null;
            return false;
        }
    }
}
