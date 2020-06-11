using System;
using System.Diagnostics;


namespace L2.exe
{
    class Program
    {
        static void Main(string[] args)
        {
            //Process[] prs = Process.GetProcesses();

            ExecuteCommand("start l2.bin IP=127.0.0.1");
            
            
        }

        static void ExecuteCommand(string command)
        {

            ProcessStartInfo processInfo;
            Process process;

            processInfo = new ProcessStartInfo("cmd.exe", "/c " + command);
            processInfo.CreateNoWindow = true;
            processInfo.UseShellExecute = false;
       
            processInfo.RedirectStandardError = false;
            processInfo.RedirectStandardOutput = false;

            process = Process.Start(processInfo);
            process.WaitForExit();


        }
    }
    }
