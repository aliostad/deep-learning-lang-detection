using System.Diagnostics;
using System.IO;

namespace NginxService
{
    public class NginxMasterProcess
    {
        private readonly NginxExeLocator _nginxExeLocator = new NginxExeLocator();
        private Process _nginxProcess;

        public void StartMasterProcess()
        {
            if (_nginxProcess == null)
            {
                _nginxProcess = new Process();
                _nginxProcess.StartInfo.FileName = _nginxExeLocator.GetNginxExePath();
                _nginxProcess.StartInfo.WindowStyle = ProcessWindowStyle.Hidden;
                _nginxProcess.Start();
            }
        }

        public void StopMasterProcess()
        {
            var signalProcess = new NginxSignalProcess();
            signalProcess.SendShutdownCommand();

            if (_nginxProcess != null)
            {
                _nginxProcess.Close();
                _nginxProcess = null;
            }
        }

        public bool IsRunning()
        {
            return File.Exists(_nginxExeLocator.GetNginxPidPath());
        }
    }
}