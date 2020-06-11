using System.Threading.Tasks;

#if WINDOWS_UWP

using Windows.UI.Core;

#endif

namespace System.Windows
{
    public abstract class JasilyDispatcher
    {
        public abstract void Invoke(Action action);

        public abstract Task InvokeAsync(Action action);

        public abstract void BeginInvoke(Action action);

        public void BeginInvoke<T1>(Action<T1> action, T1 arg1)
            => this.BeginInvoke(() => this.BeginInvoke(() => action(arg1)));

        public void BeginInvoke<T1, T2>(Action<T1, T2> action, T1 arg1, T2 arg2)
            => this.BeginInvoke(() => this.BeginInvoke(() => action(arg1, arg2)));

        public abstract bool CheckAccess();

        public bool CheckAccessOrBeginInvoke(Action action)
        {
            if (this.CheckAccess()) return true;

            this.BeginInvoke(action);
            return false;
        }

        public bool CheckAccessOrBeginInvoke<T1, T2>(Action<T1, T2> action, T1 arg1, T2 arg2)
        {
            if (this.CheckAccess()) return true;

            this.BeginInvoke(action, arg1, arg2);
            return false;
        }

        public static JasilyDispatcher GetUIDispatcher() =>
#if WINDOWS_UWP
        UWPDispatcher.UIDispatcher;
#elif DESKTOP
        DesktopDispatcher.UIDispatcher;
#elif WINDOWS_PHONE_80
        RTDispatcher.UIDispatcher;
#else
        null;
#endif
    }
}