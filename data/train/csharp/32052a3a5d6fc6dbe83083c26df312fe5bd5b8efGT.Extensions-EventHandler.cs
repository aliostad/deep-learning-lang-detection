using System;
using System.ComponentModel;

namespace GT
{
  public static partial class Extensions
  {
    public static void Raise(this EventHandler ev, 
      object sender = default(object), object eventArgs = default(EventArgs))
    {
      bool bFired = false;
      if (ev != null)
      {
        foreach (System.Delegate singleCast in ev.GetInvocationList())
        {
          bFired = false;
          try
          {
            ISynchronizeInvoke syncInvoke = 
              (ISynchronizeInvoke)singleCast.Target;
            if (syncInvoke != null && syncInvoke.InvokeRequired)
            {
              bFired = true;
              syncInvoke.Invoke(singleCast, new object[] { sender, eventArgs });
            }
            else
            {
              bFired = true;
              singleCast.DynamicInvoke(new object[] { sender, eventArgs });
            }
          }
          catch
          {
            if (!bFired)
            {
              try
              {
                singleCast.DynamicInvoke(new object[] { sender, eventArgs });
              }
              catch
              {
                throw;
              }
            }
            else
            {
              throw;
            }
          }
        }
      }
    }

    public static void Raise<T>(this EventHandler<T> ev, 
      object sender = default(object), object eventArgs = default(EventArgs)) 
      where T : EventArgs
    {
      bool bFired = false;
      if (ev != null)
      {
        foreach (System.Delegate singleCast in ev.GetInvocationList())
        {
          bFired = false;
          try
          {
            ISynchronizeInvoke syncInvoke = (ISynchronizeInvoke)singleCast.Target;
            if (syncInvoke != null && syncInvoke.InvokeRequired)
            {
              bFired = true;
              syncInvoke.Invoke(singleCast, new object[] { sender, eventArgs });
            }
            else
            {
              bFired = true;
              singleCast.DynamicInvoke(new object[] { sender, eventArgs });
            }
          }
          catch
          {
            if (!bFired)
            {
              try
              {
                singleCast.DynamicInvoke(new object[] { sender, eventArgs });
              }
              catch
              {
                throw;
              }
            }
            else
            {
              throw;
            }
          }
        }
      }
    }

    public static void Raise(this Delegate ev, object[] args)
    {
      bool bFired = false;
      if (ev != null)
      {
        foreach (System.Delegate singleCast in ev.GetInvocationList())
        {
          bFired = false;
          try
          {
            ISynchronizeInvoke syncInvoke = (ISynchronizeInvoke)singleCast.Target;
            if (syncInvoke != null && syncInvoke.InvokeRequired)
            {
              bFired = true;
              syncInvoke.Invoke(singleCast, args);
            }
            else
            {
              bFired = true;
              singleCast.DynamicInvoke(args);
            }
          }
          catch
          {
            if (!bFired)
            {
              try
              {
                singleCast.DynamicInvoke(args);
              }
              catch
              {
                throw;
              }
            }
            else
            {
              throw;
            }
          }
        }
      }
    }
  }
}
