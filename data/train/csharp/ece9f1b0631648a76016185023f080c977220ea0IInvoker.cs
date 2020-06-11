using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FrodLib.Interfaces
{
    public interface IInvoker
    {
        bool IsSynchronized { get; }

        void BeginInvoke(Action action);

        void BeginInvoke<T>(Action<T> action, T arg);

        void Invoke(Action action);
        T Invoke<T>(Func<T> func);

        Task BeginInvokeAsync(Action action);
        Task BeginInvokeAsync<T>(Action<T> action, T arg);

        Task InvokeAsync(Action action);
        Task<T> InvokeAsync<T>(Func<T> func);
    }
}
