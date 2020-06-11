using System;

namespace ChainOfResponsibility.Calcultaions
{
    class Divide : IChain
    {
        public IChain NextChain
        {
            get; set;
        }

        public void Calculate(CalculateObject calculateObject)
        {
            if (calculateObject.CalcType == CalculationType.div)
            {
                Console.WriteLine(calculateObject.FirstNumber / calculateObject.SecondNumbe);
            }
            else
            {
                NextChain.Calculate(calculateObject);
            }
        }
    }
}
