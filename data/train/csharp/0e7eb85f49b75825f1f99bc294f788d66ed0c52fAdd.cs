using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ChainOfResponsibility.Calcultaions
{
    class Add : IChain
    {
        public IChain NextChain
        {
            get; set;
        }

        public void Calculate(CalculateObject calculateObject)
        {
            if (calculateObject.CalcType == CalculationType.add)
            {
                Console.WriteLine(calculateObject.FirstNumber + calculateObject.SecondNumbe);
            }
            else
            {
                NextChain.Calculate(calculateObject);
            }
        }
    }
}
