using System;

namespace ZilLion.Core.Unities.ExtensionMethods.Common.System.Object.Invoke
{
    public static partial class Extensions
    {

        public static void SaftyInvoke<T>(this object obj, Action<T> action)
        {
            if (obj is T && action != null)
                action.Invoke((T)obj);
        }

        public static void SaftyInvoke<T>(this T obj, Action<T> action) where T : class
        {
            if (obj != default(T) && action != null)
                action.Invoke(obj);
        }

    }
}