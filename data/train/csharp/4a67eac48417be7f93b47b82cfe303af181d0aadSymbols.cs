using System;
using System.Linq.Expressions;
using System.Windows.Controls;
using XSpect.Yacq;
using XSpect.Yacq.Expressions;

namespace YacqPlugin
{
    partial class ReplWindow
    {
        internal static class Symbols
        {
            [YacqSymbol(DispatchTypes.Method, "clear")]
            public static Expression Clear(DispatchExpression e, SymbolTable s, Type t)
            {
                return YacqExpression.Dispatch(
                    s,
                    DispatchTypes.Method,
                    s.Resolve("*textbox*"),
                    "Clear"
                );
            }

            [YacqSymbol(DispatchTypes.Method, typeof(object), "printn")]
            public static Expression Write(DispatchExpression e, SymbolTable s, Type t)
            {
                return YacqExpression.Dispatch(
                    s,
                    DispatchTypes.Method,
                    s.Resolve("*textbox*"),
                    "AppendText",
                    YacqExpression.Dispatch(
                        s,
                        DispatchTypes.Method,
                        e.Left,
                        "ToString"
                    )
                );
            }

            [YacqSymbol(DispatchTypes.Method, typeof(object), "print")]
            public static Expression WriteLine(DispatchExpression e, SymbolTable s, Type t)
            {
                return YacqExpression.Dispatch(
                    s,
                    DispatchTypes.Method,
                    YacqExpression.Dispatch(
                        s,
                        DispatchTypes.Method,
                        "+",
                        YacqExpression.Dispatch(
                            s,
                            DispatchTypes.Method,
                            e.Left,
                            "ToString"
                        ),
                        Expression.Constant("\n")
                    ),
                    "printn"
                );
            }
        }
    }
}