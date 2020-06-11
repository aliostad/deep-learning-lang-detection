using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace PsGet.Hosting
{
    public interface ICommandInvoker
    {
        void InvokeScript(string script);
        IEnumerable<T> InvokeScript<T>(string script);
        IEnumerable<T> InvokeScript<T>(string script, Func<object, T> converter);
    }

    public static class CommandInvokerMixin
    {
        public static void InvokeScript(this ICommandInvoker self, string script, params object[] args)
        {
            self.InvokeScript(String.Format(script, args));
        }

        public static IEnumerable<T> InvokeScript<T>(this ICommandInvoker self, string script, params object[] args)
        {
            return self.InvokeScript<T>(String.Format(script, args));
        }

        public static IEnumerable<T> InvokeScript<T>(this ICommandInvoker self, string script, Func<object, T> converter, params object[] args)
        {
            return self.InvokeScript<T>(String.Format(script, args), converter);
        }
    }
}
