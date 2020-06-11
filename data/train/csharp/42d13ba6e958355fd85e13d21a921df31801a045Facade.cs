using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Patterns
{
    public class Facade
    {
        ComplexProcessOne p1;
        ComplexProcessTwo p2;
        ComplexProcessThree p3;

        public Facade()
        {
            p1 = new ComplexProcessOne();
            p2 = new ComplexProcessTwo();
            p3 = new ComplexProcessThree();
        }

        public void ComplexProcess()
        {
            p1.ProcessOne();
            p2.ProcessTwo();
            p3.ProcessThree();
        }

    }


    public class ComplexProcessOne
    {
        public void ProcessOne()
        {
            Console.WriteLine("Process One");
        }
    }

    public class ComplexProcessTwo
    {
        public void ProcessTwo()
        {
            Console.WriteLine("Process Two");
        }
    }

    public class ComplexProcessThree
    {
        public void ProcessThree()
        {
            Console.WriteLine("Process Three");
        }
    }

}
