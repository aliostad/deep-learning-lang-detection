using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;

namespace SampleProcessCheck
{
    class Program
    {
        static void Main(string[] args)
        {
            //-- createEnterprise("System1");



            Process current = Process.GetCurrentProcess();
            Process[] processes = Process.GetProcessesByName("SampleProcessCheck");

            Console.WriteLine("Current Process" + current.Id);
            foreach (Process process in processes)
            {

                Console.WriteLine("Other Process" + process);

                //Ignore the current process 
                //if (process.Id == current.Id)
                //{
                //    process.Kill();
                //}
            }


            Console.ReadKey();
        }
    }
}
