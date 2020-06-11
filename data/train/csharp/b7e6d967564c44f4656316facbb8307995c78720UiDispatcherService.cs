using System;
using System.Windows;
using System.Threading;
using Infrastructure.Interfaces;

namespace Infrastructure.Services
{
	// Architecture prompt: Why have this class at all?  It obviously just wraps around Application.Current.Dispatcher...
	public class UiDispatcherService : IUiDispatcherService
	{
		public void Invoke(Action toInvoke)
		{
			// Prompt: Why have this check at all?
			if(Application.Current != null && Thread.CurrentThread != Application.Current.Dispatcher.Thread)
			{
				Application.Current.Dispatcher.Invoke(toInvoke);
			}
			else
			{
				toInvoke();
			}
		}

		public void InvokeAsync(Action toInvoke)
		{
			if(Application.Current != null && Thread.CurrentThread != Application.Current.Dispatcher.Thread)
			{
				Application.Current.Dispatcher.BeginInvoke(toInvoke);
			}
			else
			{
				toInvoke();
			}
		}

		public Window CurrentApplication
		{
			get { return Application.Current != null ? Application.Current.MainWindow : null; }
		}
	}
}
