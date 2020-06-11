using System;
using System.Windows.Forms;

namespace SharpUtility.WinForm
{
    public static class FormExtensions
    {
        /// <summary>
        ///     invoke a action if required
        /// </summary>
        /// <param name="form">form</param>
        /// <param name="action">action to run</param>
        public static void InvokeIfRequired(this Form form, Action action)
        {
            if (!form.InvokeRequired)
            {
                action();
                return;
            }
            form.Invoke(action);
        }

        /// <summary>
        ///     Invoke a function if required
        /// </summary>
        /// <typeparam name="T">return type</typeparam>
        /// <param name="form">form</param>
        /// <param name="action">action to run</param>
        /// <returns>return value</returns>
        public static T InvokeIfRequired<T>(this Form form, Func<T> action)
        {
            if (!form.InvokeRequired)
            {
                return action();
            }
            return (T) form.Invoke(action);
        }

        /// <summary>
        ///     invoke a action if required
        /// </summary>
        /// <param name="control"></param>
        /// <param name="action"></param>
        public static void InvokeIfRequired(this Control control, Action action)
        {
            if (!control.InvokeRequired)
            {
                action();
                return;
            }
            control.Invoke(action);
        }

        /// <summary>
        ///     Invoke a function if required
        /// </summary>
        /// <typeparam name="T">return type</typeparam>
        /// <param name="control"></param>
        /// <param name="action"></param>
        /// <returns>return value</returns>
        public static T InvokeIfRequired<T>(this Control control, Func<T> action)
        {
            if (!control.InvokeRequired)
            {
                return action();
            }
            return (T) control.Invoke(action);
        }

        /// <summary>
        ///     Invoke a function if required
        /// </summary>
        /// <param name="uc"></param>
        /// <param name="action"></param>
        public static void InvokeIfRequired(this UserControl uc, Action action)
        {
            if (!uc.InvokeRequired)
            {
                action();
                return;
            }
            uc.Invoke(action);
        }

        /// <summary>
        ///     Invoke a function if required
        /// </summary>
        /// <typeparam name="T">return type</typeparam>
        /// <param name="uc"></param>
        /// <param name="action"></param>
        /// <returns></returns>
        public static T InvokeIfRequired<T>(this UserControl uc, Func<T> action)
        {
            if (!uc.InvokeRequired)
            {
                return action();
            }
            return (T) uc.Invoke(action);
        }

        /// <summary>
        /// Thread safe update a control
        /// </summary>
        /// <typeparam name="T">Control type</typeparam>
        /// <param name="control">Control to update</param>
        /// <param name="action">update action</param>
        public static void InvokeIfRequired<T>(this T control, Action<T> action) where T : Control
        {
            control.InvokeIfRequired(() => { action(control); });
        }
    }
}