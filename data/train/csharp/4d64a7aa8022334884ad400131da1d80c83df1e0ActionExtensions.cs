using UnityEngine;
using System.Collections;

namespace SF.Utilities.Extensions
{
	public static class ActionExtensions
	{
	    public static void SafeInvoke(this System.Action action)
	    {
	        if (action != null)
	        {
	            action.Invoke();
	        }
	    }
	    
	    public static void SafeInvoke<T>(this System.Action<T> action, T t)
	    {
	        if (action != null)
	        {
	            action.Invoke(t);
	        }
	    }
	    
	    public static void SafeInvoke<T,U>(this System.Action<T, U> action, T t, U u)
	    {
	        if (action != null)
	        {
	            action.Invoke(t, u);
	        }
	    }
	}
}
