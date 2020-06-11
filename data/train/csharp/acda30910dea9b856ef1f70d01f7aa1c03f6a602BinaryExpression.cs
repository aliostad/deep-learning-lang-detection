using System;
using System.Text;

namespace Shion.Ast
{
    [AstType("BinaryExpression")]
    public class BinaryExpression : INode, IOperation
    {
        public INode Left { get; set; }
        public INode Right { get; set; }
        public string Operator { get; set; }

        public INode New(dynamic node)
        {
            Left = AstTree.Factory(node.Left);
            Right = AstTree.Factory(node.Right);
            Operator = node.Operator;

            return this;
        }

        public override string ToString()
        {
            var sb = new StringBuilder();
            sb.Append("(");
            sb.Append(Left.ToString());
            sb.Append(" ");
            sb.Append(Operator);
            sb.Append(" ");
            sb.Append(Right.ToString());
            sb.Append(")");
            return sb.ToString();
        }

        public dynamic Invoke(Scope scope)
        {
            switch (Operator)
            {
                case "+":
                    return ((IOperation)Left).Invoke(scope) + ((IOperation)Right).Invoke(scope);
                case "-":
                    return ((IOperation)Left).Invoke(scope) - ((IOperation)Right).Invoke(scope);
                case "*":
                    return ((IOperation)Left).Invoke(scope) * ((IOperation)Right).Invoke(scope);
                case "/":
                    return ((IOperation)Left).Invoke(scope) / ((IOperation)Right).Invoke(scope);
                case ">":
                    return ((IOperation)Left).Invoke(scope) > ((IOperation)Right).Invoke(scope);
                case "<":
                    return ((IOperation)Left).Invoke(scope) < ((IOperation)Right).Invoke(scope);
                case ">=":
                    return ((IOperation)Left).Invoke(scope) >= ((IOperation)Right).Invoke(scope);
                case "<=":
                    return ((IOperation)Left).Invoke(scope) <= ((IOperation)Right).Invoke(scope);
                case "==":
                    return ((IOperation)Left).Invoke(scope).ToString() == ((IOperation)Right).Invoke(scope).ToString();
                case "===":
                    return ((IOperation)Left).Invoke(scope) == ((IOperation)Right).Invoke(scope);
                case "!=":
                    return ((IOperation)Left).Invoke(scope).ToString() != ((IOperation)Right).Invoke(scope).ToString();
                case "!==":
                    return ((IOperation)Left).Invoke(scope) != ((IOperation)Right).Invoke(scope);
                case "%":
                    return ((IOperation)Left).Invoke(scope) % ((IOperation)Right).Invoke(scope);
                case "&":
                    return ((IOperation)Left).Invoke(scope) & ((IOperation)Right).Invoke(scope);
                case "&&":
                    return ((IOperation)Left).Invoke(scope) && ((IOperation)Right).Invoke(scope);
                case "|":
                    return ((IOperation)Left).Invoke(scope) | ((IOperation)Right).Invoke(scope);
                case "||":
                    return ((IOperation)Left).Invoke(scope) || ((IOperation)Right).Invoke(scope);
                case ">>":
                    return ((IOperation)Left).Invoke(scope) >> ((IOperation)Right).Invoke(scope);
                case "<<":
                    return ((IOperation)Left).Invoke(scope) << ((IOperation)Right).Invoke(scope);
                default:
                    throw new Exception("Invalid Oprator: " + Operator);
            }
        }
    }
}