using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DesignPatterns
{
    class Runner
    {
        static void Main(string[] args) {
            SingleDispatch.Starter.Start();
            MultipleDispatchNotWorking.Starter.Start();
            MultipleDispatchWithDynamic.Starter.Start();
            MultipleDispatchWithDoubleDispatch.Starter.Start();
            MultipleDispatchWithSwitchCase.Starter.Start();
            MultipleDispatchWithReflection.Starter.Start();
            MultipleDispatchWithVisitor.Starter.Start();
            SingleDispatchInheritance.Starter.Start();

            Console.WriteLine("\nPress any key to exit");
            Console.ReadKey();
        }
    }
}
