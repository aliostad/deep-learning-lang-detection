using System;
using System.ComponentModel;
using System.Windows.Forms;

namespace InfoFenix.Application.Code {

    internal static class ControlExtension {

        #region Internal Static Methods
        
        internal static TResult SafeInvoke<T, TResult>(this T source, Func<T, TResult> function) where T : ISynchronizeInvoke {
            if (source.InvokeRequired) { return (TResult)source.Invoke(function, new object[] { source }); }
            else { return function(source); }
        }

        internal static void SafeInvoke<T>(this T source, Action<T> action) where T : ISynchronizeInvoke {
            if (source.InvokeRequired) { source.Invoke(action, new object[] { source }); }
            else { action(source); }
        }


        #endregion Internal Static Methods
    }
}