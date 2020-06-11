using System;
using System.Collections.Generic;
using System.Text;
using Xamarin.Forms;

namespace MobileCenterApp
{
	internal static class EventHandlerExtensions
	{
		public static void InvokeOnMainThread<T>(this EventHandler<T> handler, object sender, T args) where T : EventArgs
		{
			Device.BeginInvokeOnMainThread(() => handler.Invoke(sender, args));
		}

		public static void InvokeOnMainThread(this EventHandler handler, object sender, EventArgs args)
		{
			Device.BeginInvokeOnMainThread(() => handler.Invoke(sender, args));
		}

		public static void InvokeOnMainThread<T>(this EventHandler<EventArgs<T>> handler, object sender, T args)
		{
			Device.BeginInvokeOnMainThread(() => handler.Invoke(sender, new EventArgs<T>(args)));
		}

		public static void InvokeOnMainThread(this EventHandler handler, object sender)
		{
			handler.InvokeOnMainThread(sender, EventArgs.Empty);
		}

		public static void InvokeOnMainThread(this Action action)
		{
			Device.BeginInvokeOnMainThread(action.Invoke);
		}

		public static void InvokeOnMainThread<T>(this Action<T> action, T t)
		{
			Device.BeginInvokeOnMainThread(() => action.Invoke(t));
		}
	}
}