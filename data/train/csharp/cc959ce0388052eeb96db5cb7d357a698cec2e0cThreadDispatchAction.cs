namespace Frankfort.Threading.Internal
{
    using System;
    using System.Threading;
    using UnityEngine;
    using ZYSGameFramework.Util;

    public class ThreadDispatchAction<T> : DispatchAction
    {
        private T dispatchArgParam;
        private CallBackArg<T> dispatchCallArg;
        private CallBackArgRturn<T> dispatchCallArgReturn;
        private CallBack dispatchCallClean;
        private CallBackReturn dispatchCallReturn;
        private CallBackReturn<T> dispatchCallReturn2;
        public object dispatchExecutionResult;
        public T dispatchExecutionResult2;
        private bool executed;
        private bool safeMode;

        public ThreadDispatchAction()
        {
            this.executed = false;
            this.dispatchExecutionResult = null;
            this.dispatchExecutionResult2 = default(T);
        }

        public void ExecuteDispatch()
        {
            if (this.safeMode)
            {
                try
                {
                    if (this.dispatchCallClean != null)
                    {
                        this.dispatchCallClean();
                    }
                    else if (this.dispatchCallArg != null)
                    {
                        this.dispatchCallArg(this.dispatchArgParam);
                    }
                    else if (this.dispatchCallArgReturn != null)
                    {
                        this.dispatchExecutionResult = this.dispatchCallArgReturn(this.dispatchArgParam);
                    }
                    else if (this.dispatchCallReturn != null)
                    {
                        this.dispatchExecutionResult = this.dispatchCallReturn();
                    }
                    else if (this.dispatchCallReturn2 != null)
                    {
                        this.dispatchExecutionResult2 = this.dispatchCallReturn2();
                    }
                }
                catch (Exception exception)
                {
                    Debug.Log(exception.Message + exception.StackTrace);
                }
            }
            else if (this.dispatchCallClean != null)
            {
                this.dispatchCallClean();
            }
            else if (this.dispatchCallArg != null)
            {
                this.dispatchCallArg(this.dispatchArgParam);
            }
            else if (this.dispatchCallArgReturn != null)
            {
                this.dispatchExecutionResult = this.dispatchCallArgReturn(this.dispatchArgParam);
            }
            else if (this.dispatchCallReturn != null)
            {
                this.dispatchExecutionResult = this.dispatchCallReturn();
            }
            else if (this.dispatchCallReturn2 != null)
            {
                this.dispatchExecutionResult2 = this.dispatchCallReturn2();
            }
            this.executed = true;
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

        public void Init(CallBack dispatchCall, bool waitForExecution, bool safeMode)
        {
            this.safeMode = safeMode;
            this.dispatchCallClean = dispatchCall;
            this.ValidateExecutionOnInit(waitForExecution);
        }

        public void Init(CallBackArgRturn<T> dispatchCall, T dispatchArgumentParameter, bool safeMode)
        {
            this.safeMode = safeMode;
            this.dispatchCallArgReturn = dispatchCall;
            this.dispatchArgParam = dispatchArgumentParameter;
            this.ValidateExecutionOnInit(true);
        }

        public void Init(CallBackArg<T> dispatchCall, T dispatchArgumentParameter, bool waitForExecution, bool safeMode)
        {
            this.safeMode = safeMode;
            this.dispatchCallArg = dispatchCall;
            this.dispatchArgParam = dispatchArgumentParameter;
            this.ValidateExecutionOnInit(waitForExecution);
        }

        private void ValidateExecutionOnInit(bool waitForExecution)
        {
            if (waitForExecution)
            {
                if (!MainThreadWatchdog.CheckIfMainThread())
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

        public bool Executed =>
            this.executed;
    }
}

