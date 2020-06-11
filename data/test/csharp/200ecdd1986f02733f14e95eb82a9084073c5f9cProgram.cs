using System;
using System.Collections.Generic;
using System.Text;
using baileysoft.Wmi.Process;

namespace WIN32_Process
{
    class Program
    {
        static void Main(string[] args)
        {
            //Local Machine
            ProcessLocal process = new ProcessLocal();
            
            //Remote Machine
            //ProcessRemote process = new ProcessRemote("neal.bailey",
            //                                           "Cla$$ified",
            //                                           "BAILEYSOFT",
            //                                           "192.168.2.1");
            
            string processName = "notepad.exe";
            Console.WriteLine("Creating Process: " + processName);
            Console.WriteLine(process.CreateProcess(processName));
            Console.WriteLine("Setting Process Priority: Idle");
            process.SetPriority(processName, ProcessPriority.priority.IDLE);
            Console.WriteLine("Process Owner: " + process.GetProcessOwner(processName));
            Console.WriteLine("Process Owner SID: " + process.GetProcessOwnerSID(processName));

            Console.WriteLine("");

            Console.WriteLine("Properties of Process: " + processName);
            foreach (string property in process.ProcessProperties(processName))
            {
                Console.WriteLine(property);
            }

            Console.WriteLine("");
            Console.WriteLine("Killing Process: " + processName);
            process.TerminateProcess(processName);
            Console.WriteLine("Process Terminated");
            Console.ReadLine();


        }
    }
}
