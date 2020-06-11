using System;

namespace Drs.Infrastructure.Extensions
{
    public static class ActionExt
    {
        public static void SafeExecuteAction(this Action actionToInvoke)
        {
            var localAction = actionToInvoke;
            if (localAction == null)
                return;
            actionToInvoke();
        }

        public static void SafeExecuteAction<T>(this Action<T> actionToInvoke, T parameter)
        {
            var localAction = actionToInvoke;
            if (localAction == null)
                return;
            actionToInvoke(parameter);
        }
        public static void SafeExecuteAction<T1, T2>(this Action<T1, T2> actionToInvoke, T1 parameter1, T2 parameter2)
        {
            var localAction = actionToInvoke;
            if (localAction == null)
                return;
            actionToInvoke(parameter1, parameter2);
        }
    }
}
