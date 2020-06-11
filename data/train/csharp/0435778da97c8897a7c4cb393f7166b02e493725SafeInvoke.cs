using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Text;

namespace BclExtras.Threading
{
    /// <summary>
    /// Useful overrides for invoking
    /// </summary>
    public static class SafeInvoke
    {
        private static object[] EmptyObjectArray = new object[] { };

        #region Static

        public static void Invoke(this ISynchronizeInvoke target, Action callback)
        {
            InvokeImpl(target, callback);
        }

        public static void Invoke<TArg1>(this ISynchronizeInvoke target, Action<TArg1> callback, TArg1 arg1)
        {
            InvokeImpl(target, () => callback(arg1));
        }

        public static void Invoke<TArg1,TArg2>(this ISynchronizeInvoke target, Action<TArg1,TArg2> callback, TArg1 arg1, TArg2 arg2)
        {
            InvokeImpl(target, () => callback(arg1, arg2));
        }

        public static void InvokeNoThrow(this ISynchronizeInvoke target, Action callback)
        {
            InvokeImplNoThrow(target, callback);
        }

        public static void InvokeNoThrow<TArg1>(this ISynchronizeInvoke target, Action<TArg1> callback, TArg1 arg1)
        {
            InvokeImplNoThrow(target, () => callback(arg1)); 
        }

        public static void InvokeNoThrow<TArg1,TArg2>(this ISynchronizeInvoke target, Action<TArg1,TArg2> callback, TArg1 arg1, TArg2 arg2)
        {
            InvokeImplNoThrow(target, () => callback(arg1,arg2)); 
        }

        public static TReturn Invoke<TReturn>(this ISynchronizeInvoke target, Func<TReturn> del)
        {
            return InvokeImpl(target, del);
        }

        public static TReturn Invoke<TReturn,TArg1>(this ISynchronizeInvoke target, Func<TArg1, TReturn> del, TArg1 arg1)
        {
            return InvokeImpl(target, () => del(arg1)); 
        }

        public static TReturn Invoke<TReturn,TArg1,TArg2>(this ISynchronizeInvoke target, Func<TArg1,TArg2, TReturn> del, TArg1 arg1, TArg2 arg2)
        {
            return InvokeImpl(target, () => del(arg1, arg2)); 
        }

        public static TReturn InvokeNoThrow<TReturn>(this ISynchronizeInvoke target, Func<TReturn> del)
        {
            return InvokeImplNoThrow(target, del);
        }

        public static TReturn InvokeNoThrow<TReturn,TArg1>(this ISynchronizeInvoke target, Func<TArg1, TReturn> del, TArg1 arg1)
        {
            return InvokeImplNoThrow(target, () => del(arg1)); 
        }

        public static TReturn InvokeNoThrow<TReturn,TArg1,TArg2>(this ISynchronizeInvoke target, Func<TArg1,TArg2,TReturn> del, TArg1 arg1, TArg2 arg2)
        {
            return InvokeImplNoThrow(target, () => del(arg1, arg2)); 
        }

        public static IAsyncResult BeginInvoke(this ISynchronizeInvoke target, Action callback)
        {
            return BeginInvokeImpl(target, callback);
        }

        public static IAsyncResult BeginInvoke<TArg1>(this ISynchronizeInvoke target, Action<TArg1> callback, TArg1 arg1)
        {
            return BeginInvokeImpl(target, Lambda.Create(() => callback(arg1))); 
        }

        public static IAsyncResult BeginInvoke<TArg1,TArg2>(this ISynchronizeInvoke target, Action<TArg1,TArg2> callback, TArg1 arg1, TArg2 arg2)
        {
            return BeginInvokeImpl(target, Lambda.Create(() => callback(arg1, arg2))); 
        }

        public static IAsyncResult BeginInvoke<TReturn>(this ISynchronizeInvoke target, Func<TReturn> op)
        {
            return BeginInvokeImpl(target, op);
        }

        public static IAsyncResult BeginInvoke<TReturn,TArg1>(this ISynchronizeInvoke target, Func<TArg1, TReturn> op, TArg1 arg1)
        {
            return BeginInvokeImpl(target, Lambda.Create(() => op(arg1)));
        }
        
        public static IAsyncResult BeginInvokeNoThrow(this ISynchronizeInvoke target, Action callback)
        {
            return BeginInvokeImplNoThrow(target, callback);
        }

        public static IAsyncResult BeginInvokeNoThrow<TArg1>(this ISynchronizeInvoke target, Action<TArg1> callback, TArg1 arg1)
        {
            return BeginInvokeImplNoThrow(target, Lambda.Create(() => callback(arg1)));
        }

        public static IAsyncResult BeginInvokeNoThrow<TArg1,TArg2>(this ISynchronizeInvoke target, Action<TArg1,TArg2> callback, TArg1 arg1, TArg2 arg2)
        {
            return BeginInvokeImplNoThrow(target, Lambda.Create(() => callback(arg1, arg2)));
        }

        public static IAsyncResult BeginInvokeNoThrow<TReturn>(this ISynchronizeInvoke target, Func<TReturn> op)
        {
            return BeginInvokeImplNoThrow(target, op);
        }

        public static IAsyncResult BeginInvokeNoThrow<TReturn,TArg1>(this ISynchronizeInvoke target, Func<TArg1, TReturn> op, TArg1 arg1)
        {
            return BeginInvokeImplNoThrow(target, Lambda.Create(() => op(arg1)));
        }

        #endregion

        #region Core Invoke Methods

        private static void InvokeImpl(ISynchronizeInvoke invoke, Action callback)
        {
            if (invoke.InvokeRequired)
            {
                invoke.Invoke(callback, EmptyObjectArray);
            }
            else
            {
                callback();
            }
        }

        private static void InvokeImplNoThrow(ISynchronizeInvoke invoke, Action callback)
        {
            try
            {
                InvokeImpl(invoke, callback);
            }
            catch (Exception ex)
            {
                Logger.Error(FutureLogCategory.Invoke, ex.Message, ex);
            }
        }

        private static IAsyncResult BeginInvokeImpl(ISynchronizeInvoke invoke, Delegate callback)
        {
            return invoke.BeginInvoke(callback, EmptyObjectArray);
        }

        private static IAsyncResult BeginInvokeImplNoThrow(ISynchronizeInvoke invoke, Delegate callback)
        {
            try
            {
                return BeginInvokeImpl(invoke, callback);
            }
            catch (Exception ex)
            {
                Logger.Error(FutureLogCategory.BeginInvoke, ex.Message, ex);
                return null;
            }
        }

        private static T InvokeImpl<T>(ISynchronizeInvoke invoke, Func<T> op)
        {
            if (invoke.InvokeRequired)
            {
                object val = invoke.Invoke(op, EmptyObjectArray);
                return Contract.ThrowIfNotType<T>(val);
            }
            else
            {
                return op();
            }
        }

        private static T InvokeImplNoThrow<T>(ISynchronizeInvoke invoke, Func<T> op)
        {
            try
            {
                return InvokeImpl(invoke, op);
            }
            catch (Exception ex)
            {
                Logger.Error(FutureLogCategory.Invoke, ex.Message, ex);
                return default(T);
            }
        }

        #endregion
    }
}
