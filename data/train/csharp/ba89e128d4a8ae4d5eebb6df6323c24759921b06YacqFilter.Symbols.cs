using System;
using System.Linq;
using System.Linq.Expressions;
using Dulcet.Twitter;
using Inscribe.Common;
using Inscribe.Filter.Core;
using XSpect.Yacq;
using XSpect.Yacq.Expressions;

namespace YacqPlugin
{
    partial class YacqFilter
    {
        internal static class Symbols
        {
            [YacqSymbol(DispatchTypes.Unknown, null)]
            public static Expression Missing(DispatchExpression e, SymbolTable s, Type t)
            {
                Type type;
                if (e.DispatchType == DispatchTypes.Method
                    && !s.ExistsKey(DispatchTypes.Method, e.Name)
                    && (type = FilterRegistrant.GetFilter(e.Name).FirstOrDefault()) != null
                )
                {
                    return YacqExpression.Dispatch(
                        s,
                        DispatchTypes.Constructor,
                        YacqExpression.TypeCandidate(type),
                        null,
                        e.Arguments
                    )
                        .Method(s, "Filter", YacqExpression.Identifier(s, "it"));
                }
                return DispatchExpression.DefaultMissing(e, s, t);
            }
        }
    }
}
