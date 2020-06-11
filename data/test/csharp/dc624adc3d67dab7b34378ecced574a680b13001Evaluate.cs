using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ConsoleCalculator
{
    public class Evaluate
    {
        public BasicTasks calculate { get; set; }

        public Evaluate()
        {
            calculate = new BasicTasks();
        }

        public Evaluate(BasicTasks _task)
        {
            calculate = _task;
        }

        public int EvaluateThis(string expression)
        {
            calculate.IdentifyOperator(expression);


            switch (calculate.myDelimeter)
            {
                case '+':
                    return Calculation.Addition(calculate.firstNumber, calculate.secondNumber);
                case '-':
                    return Calculation.Substraction(calculate.firstNumber, calculate.secondNumber);
                case '*':
                    return Calculation.Multiplication(calculate.firstNumber, calculate.secondNumber);
                case '/':
                    return Calculation.Division(calculate.firstNumber, calculate.secondNumber);
                case '%':
                    return Calculation.Modulus(calculate.firstNumber, calculate.secondNumber);
                default:
                    throw new ArgumentException();
            }
        }
    }
}
