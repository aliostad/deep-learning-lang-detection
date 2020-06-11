using System;
using System.Collections.Generic;
using System.Linq;
using MonoMac.Foundation;
using MonoMac.AppKit;
using MonoMac.CoreAnimation;
using System.ComponentModel;

namespace Xamarin.Canvas.Mac
{
	public class UISyncInvoke : NSObject, ISynchronizeInvoke
	{
		#region ISynchronizeInvoke implementation

		public IAsyncResult BeginInvoke (Delegate method, object[] args)
		{
			InvokeOnMainThread (() => method.DynamicInvoke (args));
			return null;
		}

		public object EndInvoke (IAsyncResult result)
		{
			return null;
		}

		public object Invoke (Delegate method, object[] args)
		{
			InvokeOnMainThread (() => method.DynamicInvoke (args));
			return null;
		}

		public bool InvokeRequired {
			get { return true; }
		}

		#endregion


	}
	
}
