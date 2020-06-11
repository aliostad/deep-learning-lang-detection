namespace CalculatorTest.Process
{
    using System.Configuration;
    using System.Diagnostics;

    public class CalculatorProcess
    {
        private readonly Process Process;
        public int ProcessId
        {
            get
            {
                return Process.Id;
            }
        }


        public CalculatorProcess()
        {
            Process = new Process();
            Process.StartInfo.FileName = ConfigurationManager.AppSettings["ExecutablePath"];
            Process.StartInfo.WindowStyle = ProcessWindowStyle.Maximized;
            Process.Start();
        }

        public void Stop()
        {
            Process.Close();
        }
    }
}
