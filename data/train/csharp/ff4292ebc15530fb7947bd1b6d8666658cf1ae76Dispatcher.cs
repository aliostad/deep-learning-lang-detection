using UnityEngine.Events;

namespace Wirune.W03
{
    public static class Dispatcher
    {
        public static void Invoke(UnityAction action)
        {
            if (null != action)
            {
                action.Invoke();
            }
        }

        public static void Invoke<TParam1>(UnityAction<TParam1> action, TParam1 p1)
        {
            if (null != action)
            {
                action.Invoke(p1);
            }
        }

        public static void Invoke<TParam1, TParam2>(UnityAction<TParam1, TParam2> action, TParam1 p1, TParam2 p2)
        {
            if (null != action)
            {
                action.Invoke(p1, p2);
            }
        }
    }
}

