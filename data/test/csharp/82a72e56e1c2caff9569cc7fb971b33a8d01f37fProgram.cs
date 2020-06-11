using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace tryOnEx25
{
    class Program
    {
        static void Main(string[] args)
        {
            var Process = new Process();
            Console.WriteLine("Process: " + Process.CurrentState);
            Process.Walk();
            Console.WriteLine("Process: " + Process.CurrentState);
            Process.Start();
            Console.WriteLine("Process: " + Process.CurrentState);
            Process.Stop();
            Console.WriteLine("Process: " + Process.CurrentState);
            Process.Walk();
            Console.ReadKey();
        }
    }
}
