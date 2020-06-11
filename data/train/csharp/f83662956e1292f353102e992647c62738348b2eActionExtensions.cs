using System;

public static class ActionExtensions
{
    public static void Invoke(this Action action, bool checkNull)
    {
        if (action != null)
        {
            action();
        }
    }

    public static void Invoke<T>(this Action<T> action,T obj, bool checkNull)
    {
        if (action != null)
        {
            action.Invoke(obj);
        }
    }

    public static void Invoke<T1, T2>(this Action<T1, T2> action, T1 obj, T2 obj2, bool checkNull)
    {
        if (action != null)
        {
            action.Invoke(obj, obj2);
        }
    }
}
