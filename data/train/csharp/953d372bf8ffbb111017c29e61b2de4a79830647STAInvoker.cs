using System;
using System.Threading;

namespace sapHowmuch.Base.Helpers
{
	public class STAInvoker<T, TReturn>
	{
		private readonly Thread _invokeThread;
		private readonly Func<T, TReturn> _invoker;
		private TReturn _result;
		private readonly T _staThreadObject;

		public STAInvoker(T staThreadObject, Func<T, TReturn> invoker)
		{
			this._staThreadObject = staThreadObject;
			this._invoker = invoker;
			this._invokeThread = new Thread(InvokeMethod) { IsBackground = true };
			this._invokeThread.SetApartmentState(ApartmentState.STA);
		}

		public TReturn Invoke()
		{
			this._invokeThread.Start();
			this._invokeThread.Join();

			return _result;
		}

		private void InvokeMethod()
		{
			_result = _invoker.Invoke(_staThreadObject);
		}
	}
}