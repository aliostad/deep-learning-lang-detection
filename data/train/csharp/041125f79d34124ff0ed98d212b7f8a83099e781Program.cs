using System;
using System.Diagnostics;
using System.Linq;

namespace ConsoleApplication1
{
    class Program
    {
        static void Main(string[] args)
        {
            var processList =
                from process in Process.GetProcesses()
                orderby process.Threads.Count descending, 
                        process.ProcessName ascending
                select new
                {
                    process.ProcessName,
                    ThreadCount = process.Threads.Count
                };

            Console.WriteLine("Process List");
            foreach (var process in processList)
            {
                Console.WriteLine("{0,25} {1,4:D}", process.ProcessName, process.ThreadCount);
            }
        }
    }
}
