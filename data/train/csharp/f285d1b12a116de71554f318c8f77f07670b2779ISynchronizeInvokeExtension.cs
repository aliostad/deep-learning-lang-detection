using System;
using System.ComponentModel;
//taken from http://stackoverflow.com/questions/711408/best-way-to-invoke-any-cross-threaded-code/711419#711419
// easy way to access fields of ui components
namespace Buckets
{
    public static class ISynchronizeInvokeExtension
    {
        public static void InvokeEx<T>(this T @this, Action<T> action) where T : ISynchronizeInvoke
        {
            if (@this.InvokeRequired)
            {
                @this.BeginInvoke(action, new object[] { @this });
            }
            else
            {
                action.BeginInvoke(@this, null, null);
            }
        }
    }
}
