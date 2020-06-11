using System;
using System.ComponentModel;

namespace McKesson.Azure.ProvisionUsers.Extensions
{
    /// <summary>
    /// prevent cross threding with ui thread after task done and you want to update ui.
    /// usage: listView1.InvokeEx(lv => lv.Items.Clear());
    /// </summary>
    /// <see cref="http://stackoverflow.com/questions/711408/best-way-to-invoke-any-cross-threaded-code/711419#711419"/>
    public static class SynchronizeInvokeExtensions
    {
        public static void InvokeEx<T>(this T @this, Action<T> action, bool useInvoke = true) where T : ISynchronizeInvoke
        {
            if (!useInvoke)
            {
                action(@this);
            }
            else if (@this.InvokeRequired)
            {
                @this.Invoke(action, new object[] {@this});
            }
            else
            {
                action(@this);
            }
        }
    }
}
