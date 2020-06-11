namespace GPG.Threading
{
    using System;
    using System.Reflection;
    using System.Threading;

    public class ThreadItem
    {
        private MethodInfo _CallbackMethod;
        private object _CallbackTarget;
        private Thread _CallbackThread;
        private MethodInfo _InvokeMethod;
        private object[] _InvokeParams;
        private object _InvokeTarget;

        public ThreadItem(object target, MethodInfo invoke, MethodInfo callback, params object[] invokeParams)
        {
            this._InvokeTarget = target;
            this._CallbackTarget = target;
            this._InvokeMethod = invoke;
            this._CallbackMethod = callback;
            this._InvokeParams = invokeParams;
            this._CallbackThread = Thread.CurrentThread;
        }

        public ThreadItem(object invokeTarget, object callbackTarget, MethodInfo invoke, MethodInfo callback, params object[] invokeParams)
        {
            this._InvokeTarget = invokeTarget;
            this._CallbackTarget = callbackTarget;
            this._InvokeMethod = invoke;
            this._CallbackMethod = callback;
            this._InvokeParams = invokeParams;
            this._CallbackThread = Thread.CurrentThread;
        }

        public override string ToString()
        {
            string str = "";
            if (this.InvokeParams != null)
            {
                for (int i = 0; i < this.InvokeParams.Length; i++)
                {
                    str = str + string.Format("{0},", this.InvokeParams[i]);
                }
                str = str.TrimEnd(new char[] { ',' });
            }
            return string.Format("Invoke: {0}.{1}({2})\r\nCallback: {3}.{4}({5})", new object[] { this.InvokeTarget, this.InvokeMethod.Name, str, this.CallbackTarget, this.CallbackMethod, this.InvokeMethod.ReturnType });
        }

        public MethodInfo CallbackMethod
        {
            get
            {
                return this._CallbackMethod;
            }
        }

        public object CallbackTarget
        {
            get
            {
                return this._CallbackTarget;
            }
        }

        public Thread CallbackThread
        {
            get
            {
                return this._CallbackThread;
            }
        }

        public MethodInfo InvokeMethod
        {
            get
            {
                return this._InvokeMethod;
            }
        }

        public object[] InvokeParams
        {
            get
            {
                return this._InvokeParams;
            }
        }

        public object InvokeTarget
        {
            get
            {
                return this._InvokeTarget;
            }
        }
    }
}

