using System;
using System.ComponentModel;
using System.IO;
using System.Net;
using System.Threading.Tasks;

namespace VK.Logic
{
    public static class ISynchronizeInvokeExtensions
    {
        public static void InvokeEx<T>(this T @this, Action<T> action) where T : ISynchronizeInvoke
        {
            try
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
            catch (Exception e)
            {
                Console.WriteLine(e);
            }
        }
    }
}
