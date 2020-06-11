using System.Diagnostics;

namespace CrazyIIS
{
    class IIS
    {
        public static void Stop()
        {
            Process cmdProcess = new Process();
            cmdProcess.StartInfo.FileName = "iisreset";
            cmdProcess.StartInfo.Arguments = " /stop";
            cmdProcess.StartInfo.WindowStyle = ProcessWindowStyle.Hidden;
            cmdProcess.Start();
            cmdProcess.WaitForExit();
            cmdProcess.Close();


        }
        public static void Start()
        {
            Process cmdProcess = new Process();
            cmdProcess.StartInfo.FileName = "iisreset";
            cmdProcess.StartInfo.Arguments = " /start";
            cmdProcess.StartInfo.WindowStyle = ProcessWindowStyle.Hidden;
            cmdProcess.Start();
            cmdProcess.WaitForExit();
            cmdProcess.Close();
        }

        public static void Reset()
        {
            Process cmdProcess = new Process();
            cmdProcess.StartInfo.FileName = "iisreset";
            cmdProcess.StartInfo.WindowStyle = ProcessWindowStyle.Hidden;
            cmdProcess.Start();
            cmdProcess.WaitForExit();
            cmdProcess.Close();


            //Process.Start("iisreset");//重启  
        }

    }
}
