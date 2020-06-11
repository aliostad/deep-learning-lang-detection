using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace run
{
    class Program
    {
        static void Main(string[] args)
        {
            Process myProcess = new Process();
            myProcess.StartInfo.FileName = "notepad.exe";
            myProcess.Start();
            Console.WriteLine("Process started " + myProcess.ProcessName);
            myProcess.WaitForExit();
            Console.WriteLine("Process code " + myProcess.ExitCode);
            Console.WriteLine("Current process name " + Process.GetCurrentProcess().ProcessName);
        }
    }
}
