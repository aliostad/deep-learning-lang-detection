using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DynInvoke
{
    class Program
    {
        static void Main(string[] args)
        {
            A a = new A();
            B b = new B();
            C c = new C();

            InvokeHello(a, "Thalia");
            InvokeHello(b, "Or");
            InvokeHello(c, "Dan");
        }

        static void InvokeHello(object o, string s)
        {
            Console.WriteLine(o.GetType().GetMethod("Hello").Invoke(o, new []{s}));
        }
    }
}
