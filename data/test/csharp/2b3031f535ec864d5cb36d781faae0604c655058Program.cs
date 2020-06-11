using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TPLTester
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Starting parallel work");
            Parallel.Invoke(()=>Console.WriteLine("1"));
            Parallel.Invoke(()=>Console.WriteLine("2"));
            Parallel.Invoke(()=>Console.WriteLine("3"));
            Parallel.Invoke(()=>Console.WriteLine("4"));
            Parallel.Invoke(()=>Console.WriteLine("5"));
            Parallel.Invoke(()=>Console.WriteLine("6"));
            Console.Read();
        }
    }
}
