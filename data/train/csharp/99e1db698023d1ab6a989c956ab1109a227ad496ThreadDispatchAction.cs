using System;
using System.Threading;
using Tools;
using UnityEngine;
namespace Frankfort.Threading.Internal
{
	public class ThreadDispatchAction<T> : DispatchAction
	{
		private bool executed = false;
		public object dispatchExecutionResult = null;
		public T dispatchExecutionResult2 = default(T);
		private CallBack dispatchCallClean;
		private CallBackArg<T> dispatchCallArg;
		private CallBackArgRturn<T> dispatchCallArgReturn;
		private CallBackReturn<T> dispatchCallReturn2;
		private CallBackReturn dispatchCallReturn;
		private T dispatchArgParam;
		private bool safeMode;
		public bool Executed
		{
			get
			{
				return this.executed;
			}
		}
		public void Init(CallBack dispatchCall, bool waitForExecution, bool safeMode)
		{
			this.safeMode = safeMode;
			this.dispatchCallClean = dispatchCall;
			this.ValidateExecutionOnInit(waitForExecution);
		}
		public void Init(CallBackArg<T> dispatchCall, T dispatchArgumentParameter, bool waitForExecution, bool safeMode)
		{
			this.safeMode = safeMode;
			this.dispatchCallArg = dispatchCall;
			this.dispatchArgParam = dispatchArgumentParameter;
			this.ValidateExecutionOnInit(waitForExecution);
		}
		public void Init(CallBackArgRturn<T> dispatchCall, T dispatchArgumentParameter, bool safeMode)
		{
			this.safeMode = safeMode;
			this.dispatchCallArgReturn = dispatchCall;
			this.dispatchArgParam = dispatchArgumentParameter;
			this.ValidateExecutionOnInit(true);
		}
		public void Init(CallBackReturn dispatchCall, bool safeMode)
		{
			this.safeMode = safeMode;
			this.dispatchCallReturn = dispatchCall;
			this.ValidateExecutionOnInit(true);
		}
		public void Init(CallBackReturn<T> dispatchCall, bool safeMode)
		{
			this.safeMode = safeMode;
			this.dispatchCallReturn2 = dispatchCall;
			this.ValidateExecutionOnInit(true);
		}
		private void ValidateExecutionOnInit(bool waitForExecution)
		{
			if (waitForExecution)
			{
				bool flag = !MainThreadWatchdog.CheckIfMainThread();
				if (flag)
				{
					while (!this.executed && Loom.CheckUnityActive())
					{
						Thread.Sleep(5);
					}
				}
				else
				{
					this.ExecuteDispatch();
				}
			}
		}
		public void ExecuteDispatch()
		{
			bool flag = this.safeMode;
			if (flag)
			{
				try
				{
					bool flag2 = this.dispatchCallClean != null;
					if (flag2)
					{
						this.dispatchCallClean();
					}
					else
					{
						bool flag3 = this.dispatchCallArg != null;
						if (flag3)
						{
							this.dispatchCallArg(this.dispatchArgParam);
						}
						else
						{
							bool flag4 = this.dispatchCallArgReturn != null;
							if (flag4)
							{
								this.dispatchExecutionResult = this.dispatchCallArgReturn(this.dispatchArgParam);
							}
							else
							{
								bool flag5 = this.dispatchCallReturn != null;
								if (flag5)
								{
									this.dispatchExecutionResult = this.dispatchCallReturn();
								}
								else
								{
									bool flag6 = this.dispatchCallReturn2 != null;
									if (flag6)
									{
										this.dispatchExecutionResult2 = this.dispatchCallReturn2();
									}
								}
							}
						}
					}
				}
				catch (Exception ex)
				{
					Debug.Log(ex.Message + ex.StackTrace);
				}
			}
			else
			{
				bool flag7 = this.dispatchCallClean != null;
				if (flag7)
				{
					this.dispatchCallClean();
				}
				else
				{
					bool flag8 = this.dispatchCallArg != null;
					if (flag8)
					{
						this.dispatchCallArg(this.dispatchArgParam);
					}
					else
					{
						bool flag9 = this.dispatchCallArgReturn != null;
						if (flag9)
						{
							this.dispatchExecutionResult = this.dispatchCallArgReturn(this.dispatchArgParam);
						}
						else
						{
							bool flag10 = this.dispatchCallReturn != null;
							if (flag10)
							{
								this.dispatchExecutionResult = this.dispatchCallReturn();
							}
							else
							{
								bool flag11 = this.dispatchCallReturn2 != null;
								if (flag11)
								{
									this.dispatchExecutionResult2 = this.dispatchCallReturn2();
								}
							}
						}
					}
				}
			}
			this.executed = true;
		}
	}
}
