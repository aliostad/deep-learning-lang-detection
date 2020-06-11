using System;
using System.Threading.Tasks;

namespace BioInfo.App.Library.Common.Helpers
{
    public static class InvocationHelper
    {
        public static T ExecuteWithExceptionHandling<T>(this Func<T> codeToInvoke, string exceptionString = "", Func<T> codeToInvokeOnFail = null)
        {
            try
            {
                return codeToInvoke.Invoke();
            }
            catch (Exception e)
            {
                if (codeToInvokeOnFail != null)
                {
                    return codeToInvokeOnFail.Invoke();
                }

                throw;
            }
        }

        public static void ExecuteWithExceptionHandling(this Action codeToInvoke, string exceptionString = "", Action codeToInvokeOnFail = null)
        {
            try
            {
                codeToInvoke.Invoke();
            }
            catch (Exception e)
            {
                if (codeToInvokeOnFail != null)
                {
                    codeToInvokeOnFail.Invoke();
                }

                throw;
            }
        }

        public static void WithClient<T>(this T proxy, Action<T> codeToExecute)
        {
            codeToExecute.Invoke(proxy);
            var disposableClient = proxy as IDisposable;
            if (disposableClient != null)
            {
                disposableClient.Dispose();
            }
        }
        public static void ExecuteWithIgnoreException(this Action codeToInvoke, Action codeToInvokeOnFail = null)
        {
            try
            {
                codeToInvoke.Invoke();
            }
            catch (Exception e)
            {
                if (codeToInvokeOnFail != null)
                {
                    codeToInvokeOnFail.Invoke();
                }
            }
        }

        public static T ExecuteWithIgnoreException<T>(this Func<T> codeToInvoke, Func<T> codeToInvokeOnFail = null)
        {
            try
            {
                return codeToInvoke.Invoke();
            }
            catch (Exception e)
            {
                if (codeToInvokeOnFail != null)
                {
                    return codeToInvokeOnFail();
                }
                return default(T);
            }
        }
    }
}
