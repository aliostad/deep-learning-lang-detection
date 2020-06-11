using System;
using System.Collections.Generic;
using System.Text;
using System.Threading;
using System.Windows.Forms;

namespace Laugris.Sage
{
    /// <summary>
    /// The same as invocator, but linked to the window
    /// </summary>
    public sealed class InvokeProcessor : IDisposable
    {
        private Queue<InvokeObjectHandler> queue;
        private IntPtr handle;

        public InvokeProcessor(IntPtr handle)
        {
            this.handle = handle;
            queue = new Queue<InvokeObjectHandler>();
        }

        ~InvokeProcessor()
        {
            Dispose(false);
        }

        public void ExecuteRequest()
        {
            InvokeObjectHandler method = null;

            lock (this.queue)
            {
                if (queue.Count > 0)
                {
                    method = queue.Dequeue();
                }
            }

            if (method != null)
            {
                try
                {
                    if (method.Entry != null)
                        method.Entry(method.Parameter);
                }
                catch (Exception ex)
                {
                    InvocationException ie = new InvocationException(method.ErrorMessage, ex);
                    Application.OnThreadException(ie);
                }
            }
        }

        public void BeginInvoke(WaitCallback method)
        {
            InvokeObjectHandler entry = new InvokeObjectHandler(method);
            queue.Enqueue(entry);
            NativeMethods.PostMessage(handle, NativeMethods.CN_BEGININVOKE, IntPtr.Zero, IntPtr.Zero);
        }

        public void BeginInvoke(WaitCallback method, object parameter)
        {
            InvokeObjectHandler entry = new InvokeObjectHandler(method, parameter);
            queue.Enqueue(entry);
            NativeMethods.PostMessage(handle, NativeMethods.CN_BEGININVOKE, IntPtr.Zero, IntPtr.Zero);
        }

        public void BeginInvoke(WaitCallback method, object parameter, string errorMessage)
        {
            InvokeObjectHandler entry = new InvokeObjectHandler(method, parameter, errorMessage);
            queue.Enqueue(entry);
            NativeMethods.PostMessage(handle, NativeMethods.CN_BEGININVOKE, IntPtr.Zero, IntPtr.Zero);
        }

        public void BeginInvoke(WaitCallback method, string errorMessage)
        {
            InvokeObjectHandler entry = new InvokeObjectHandler(method, errorMessage);
            queue.Enqueue(entry);
            NativeMethods.PostMessage(handle, NativeMethods.CN_BEGININVOKE, IntPtr.Zero, IntPtr.Zero);
        }

        #region INVOKE
        public void Invoke(WaitCallback method)
        {
            InvokeObjectHandler entry = new InvokeObjectHandler(method);
            queue.Enqueue(entry);
            NativeMethods.SendMessage(handle, NativeMethods.CN_INVOKE, IntPtr.Zero, IntPtr.Zero);
        }

        public void Invoke(WaitCallback method, object parameter)
        {
            InvokeObjectHandler entry = new InvokeObjectHandler(method, parameter);
            queue.Enqueue(entry);
            NativeMethods.SendMessage(handle, NativeMethods.CN_INVOKE, IntPtr.Zero, IntPtr.Zero);
        }

        public void Invoke(WaitCallback method, object parameter, string errorMessage)
        {
            InvokeObjectHandler entry = new InvokeObjectHandler(method, parameter, errorMessage);
            queue.Enqueue(entry);
            NativeMethods.SendMessage(handle, NativeMethods.CN_INVOKE, IntPtr.Zero, IntPtr.Zero);
        }

        public void Invoke(WaitCallback method, string errorMessage)
        {
            InvokeObjectHandler entry = new InvokeObjectHandler(method, errorMessage);
            queue.Enqueue(entry);
            NativeMethods.SendMessage(handle, NativeMethods.CN_INVOKE, IntPtr.Zero, IntPtr.Zero);
        }
        #endregion
        public void Clear()
        {
            queue.Clear();
        }

        private void Dispose(bool disposing)
        {
            queue.Clear();
        }

        public void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }

    }
}
