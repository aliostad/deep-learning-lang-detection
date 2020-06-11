using System;

public static class ActionExtension
{
    public static void SafeInvoke(this Action self)
    {
        if (self != null)
        {
            self.Invoke();
        }
    }
    public static void SafeInvoke<T>(this Action<T> self,T value)
    {
        if(self != null)
        {
            self.Invoke(value);
        }
    }
    public static void SafeInvoke<T1, T2>(this Action<T1, T2> self, T1 value1, T2 value2)
    {
        if (self != null)
        {
            self.Invoke(value1, value2);
        }
    }
}
