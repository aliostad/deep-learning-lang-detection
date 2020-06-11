using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;

namespace DynInvoke
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine(InvokeHello(new A(), "I'm A"));
            Console.WriteLine(InvokeHello(new B(), "I'm B"));
            Console.WriteLine(InvokeHello(new C(), "I'm C"));
        }

        public static string InvokeHello(Object obj, String str)
        {
            return obj.GetType().InvokeMember("Hello", BindingFlags.InvokeMethod, null, obj, new object[] { str }).ToString();
        }
    }
} 
