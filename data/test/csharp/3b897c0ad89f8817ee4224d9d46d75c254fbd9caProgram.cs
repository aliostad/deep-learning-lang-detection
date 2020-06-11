using Calculator;
using System;

namespace TestClassLibrayCalculator
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Static Key- " + Calculate.Add(1, 2) + "  " + Calculate.Add(1, 2, 3, 4));


            Calculate aCalculate = new Calculate();
            double result = aCalculate.Multiply(3, 3, 3, 3);
            Console.WriteLine("Object create Multiply " + result);

            Calculate aCalculateSub = new Calculate();
            double resultSub = aCalculateSub.Substractor(3, 3, 3, 3);
            Console.WriteLine("Object create Substrator " + resultSub);


            Console.WriteLine("CalculateTwo Class below:");
            Console.WriteLine(CalculateAbstract.Substractor(30, 3));





            Console.ReadKey();
        }
    }
}
