using System;

namespace Rasengan.Operations
{
    public class BinaryExpressionOperation : IOperation
    {
        private IOperation _left;
        private IOperation _rigth;
        private string _operation;

        public BinaryExpressionOperation(dynamic expression)
        {
            _left = OpFactory.Factory(expression.Left);
            _rigth = OpFactory.Factory(expression.Right);
            _operation = expression.Operator;
        }


        public dynamic Invoke(Context context)
        {
            switch (_operation)
            {
                case "+":
                    return _left.Invoke(context) + _rigth.Invoke(context);
                case "-":
                    return _left.Invoke(context) - _rigth.Invoke(context);
                case "*":
                    return _left.Invoke(context) * _rigth.Invoke(context);
                case "/":
                    return _left.Invoke(context) / _rigth.Invoke(context);
                case ">":
                    return _left.Invoke(context) > _rigth.Invoke(context);
                case "<":
                    return _left.Invoke(context) < _rigth.Invoke(context);
                case ">=":
                    return _left.Invoke(context) >= _rigth.Invoke(context);
                case "<=":
                    return _left.Invoke(context) <= _rigth.Invoke(context);
                case "==":
                    return _left.Invoke(context).ToString() == _rigth.Invoke(context).ToString();
                case "===":
                    return _left.Invoke(context) == _rigth.Invoke(context);
                case "!=":
                    return _left.Invoke(context).ToString() != _rigth.Invoke(context).ToString();
                case "!==":
                    return _left.Invoke(context) != _rigth.Invoke(context);
                case "%":
                    return _left.Invoke(context) % _rigth.Invoke(context);
                case "&":
                    return _left.Invoke(context) & _rigth.Invoke(context);
                case "&&":
                    return _left.Invoke(context) && _rigth.Invoke(context);
                case "|":
                    return _left.Invoke(context) | _rigth.Invoke(context);
                case "||":
                    return _left.Invoke(context) || _rigth.Invoke(context);
                default:
                    throw new Exception("Invalid Oprator: " + _operation);
            }
        }
    }
}