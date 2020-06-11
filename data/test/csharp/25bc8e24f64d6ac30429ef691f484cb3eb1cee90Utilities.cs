namespace PassiveViewPattern
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel;
    using System.Linq.Expressions;
    using System.Text;

    public sealed class Utilities
    {
        public static void InvokeIfNeeded<T>(T control, Expression<Action> action) where T : IInvokable
        {
            if (control.InvokeRequired)
            {
                control.Invoke(new Action(() => InvokeIfNeeded(control, action)));
                return;
            }
            action.Compile().Invoke();
        }
        public static void InvokeIfNeeded(IInvokable control, Action method)
        {
            if (control.InvokeRequired)
            {
                control.Invoke(new Action(() => InvokeIfNeeded(control, method)));
                return;
            }

            method();
        }
        public static void InvokeIfNeeded<T>(T control, Action<T> method) where T : ISynchronizeInvoke
        {
            if (control.InvokeRequired)
            {
                control.Invoke(new Action(() => InvokeIfNeeded(control, method)), null);
                return;
            }

            method(control);
        }
        public static void InvokeIfNeeded<T>(T control, string method, object parameter) where T : IInvokable
        {
            if (control.InvokeRequired)
            {
                control.Invoke(new Action(() => InvokeIfNeeded(control, method, parameter)));
                return;
            }

            control.GetType().GetMethod(method).Invoke(control, new[] { parameter });
        }
        public static void InvokeIfNeeded<T>(T control, string method) where T : IInvokable
        {
            if (control.InvokeRequired)
            {
                control.Invoke(new Action(() => InvokeIfNeeded(control, method)));
                return;
            }

            control.GetType().GetMethod(method).Invoke(control, new object[] { });
        }
        public static void RaiseEvent(EventHandler eventHandler, object sender, EventArgs args)
        {
            if (eventHandler != null)
            {
                eventHandler(sender, args);
            }
        }
    }
}
