using Ninject.Extensions.Interception;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ParkerFox.Infrastructure.IoC
{
    public class BenchMarkInterceptor : SimpleInterceptor
    {
        protected override void BeforeInvoke(IInvocation invocation)
        {
            Debug.WriteLine("before invoke");
            base.BeforeInvoke(invocation);
        }

        protected override void AfterInvoke(IInvocation invocation)
        {
            base.AfterInvoke(invocation);
        }
    }
}
