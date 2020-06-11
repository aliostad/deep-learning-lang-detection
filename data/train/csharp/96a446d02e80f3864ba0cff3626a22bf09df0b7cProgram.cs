using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace invoke
{
    class Program
    {
        public static int counterA;
        public static int counterB;
        static void Main(string[] args)
        {
            counterA = counterB = 0;
            try
            {
                invokeA();
            }
            catch (System.Exception ex)
            {
                System.Console.WriteLine(ex.Message);
            }
        }

        public static void invokeA()
        {
            counterA++;
            System.Console.WriteLine("invoke A {0}", counterA);
            invokeB();
        }

        public static void invokeB()
        {
            counterB++;
            System.Console.WriteLine("invoke B {0}", counterB);
            invokeA();
        }
    }
}
