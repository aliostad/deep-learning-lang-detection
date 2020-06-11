using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SS.Integration.Common.Extensions
{
    public static class EventExtensions
    {
        public static void InvokeIfNotNull(this EventHandler handler, object owner = null)
        {
            handler?.Invoke(owner, EventArgs.Empty);
        }
        public static void InvokeIfNotNull<T>(this EventHandler<T> handler, T t, object owner = null)
        {
            handler?.Invoke(owner, t);
        }

        public static void InvokeIfNotNull<T>(this EventHandler<T> handler, Func<T> predicate, object owner = null)
        {
            handler?.Invoke(owner, predicate.Invoke());
        }

        public static void InvokeIfNotNull<T1, T2>(this Action<T1, T2> handler, T1 t1, T2 t2)
        {
            handler?.Invoke(t1, t2);
        }
    }
}
