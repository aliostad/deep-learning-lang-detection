using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Mirza09112017.DesignPatterns.Factory
{
    public enum calculateType { CalculateA, CalculateB, CalculateC };
    public class CalculateFactory
    {
        public ICalculate CreateCalculate(calculateType type)
        {
            switch(type)
            {
                case calculateType.CalculateA:
                    return new CalculateA();
                case calculateType.CalculateB:
                    return new CalculateB();
                case calculateType.CalculateC:
                    return new CalculateC();
                default:
                    throw new ArgumentException();
            }

        }
    }
}
