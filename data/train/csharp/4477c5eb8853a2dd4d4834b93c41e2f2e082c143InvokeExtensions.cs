using System;
using System.ComponentModel;

namespace Atlas.Extensions
{
    public static class InvokeExtensions
    {
        /// <summary>
        /// <para>Invoke Extension.</para>
        /// <para>Hides invoke check and subsequent invoke</para>
        /// <para>Syntactical sugar: </para>
        /// <para>eg, this.InvokeExt(t => ...)</para>
        /// </summary>
        public static void InvokeExt<T>(this T @this, Action<T> action) where T : ISynchronizeInvoke
        {
            if (@this.InvokeRequired)
            {
                @this.Invoke(action, new object[] {@this});
                return;
            }
            action(@this);
        }
    }
}