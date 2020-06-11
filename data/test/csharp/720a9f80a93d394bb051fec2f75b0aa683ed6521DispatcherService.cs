using System;
using System.Windows;
using System.Windows.Threading;

namespace TranslationHelper.Helpers
{
    public interface IDispatchService
    {
        void Invoke(Action action);
        TResult Invoke<TResult>(Func<TResult> callback);
    }

    public class DispatchService : IDispatchService
    {
        public void Invoke(Action action)
        {
            Dispatcher dispatchObject = Application.Current.Dispatcher;
            
            if (dispatchObject == null || dispatchObject.CheckAccess())
                action();
            else
                dispatchObject.Invoke(action);
        }

        public TResult Invoke<TResult>(Func<TResult> callback)
        {
            Dispatcher dispatchObject = Application.Current.Dispatcher;

            if (dispatchObject == null || dispatchObject.CheckAccess())
                return callback();
            
            return dispatchObject.Invoke(callback);   
        }
    }
}
