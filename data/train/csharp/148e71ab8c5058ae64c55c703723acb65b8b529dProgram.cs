using System;
using System.Diagnostics;
using System.IO;

namespace lab09
{
    class Program
    {
        static void Main(string[] args)
        {
            // Classes Process and ProcessThread

            var processes = Process.GetProcesses();

            foreach (Process process in processes)
            {
                Console.WriteLine("Process ID: {0}\tName: {1}", process.Id, process.ProcessName);

                foreach (ProcessThread thread in process.Threads)
                    Console.WriteLine("\t Thread ID: {0}", thread.Id);
            }


            Console.ReadLine();
        }
    }
}
