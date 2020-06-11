using System;
using System.ComponentModel;

namespace ACProject.Extensions
{
    /// <summary>
    /// Extension method for ISycnchronizeInvoke interface to let GUI elements be updated in other thread.
    /// </summary>
    public static class ISynchronizeInvokeExtensions
    {
        public static void InvokeEx<T>(this T @this, Action<T> action) where T : ISynchronizeInvoke
        {
            if (@this.InvokeRequired)
            {
                @this.Invoke(action, new object[] { @this });
            }
            else
            {
                action(@this);
            }
        }
    }
}