using UnityEngine;
using System;
using System.Collections;

namespace UnityOps.UnityAsync
{
    [Serializable]
    /// <summary>
    /// Invoke after frame.
    /// From this object, progress is unreceivable.
    /// </summary>
    public class InvokeAfterFrame : AsyncOperationScript<OperationOutputs, AsyncOperationErrors, OperationProgress>
    {
        #region properties
        protected Action delayInvokeCallback;
        int delayFrame;
        int startFrame;
        #endregion

        #region public methods
        public static InvokeAfterFrame Call(Action callback)
        {
            InvokeAfterFrame asyncOps = new InvokeAfterFrame(callback);
            asyncOps.Execute();
            return asyncOps;
        }

        public static InvokeAfterFrame Call(Action callback, int delayFrame)
        {
            InvokeAfterFrame asyncOps = new InvokeAfterFrame(callback, delayFrame);
            asyncOps.Execute();
            return asyncOps;
        }

        public static InvokeAfterFrame Call(int delayFrame, Action callback)
        {
            InvokeAfterFrame asyncOps = new InvokeAfterFrame(delayFrame, callback);
            asyncOps.Execute();
            return asyncOps;
        }

        public static InvokeAfterFrame Call(string name, Action callback, int delayFrame)
        {
            InvokeAfterFrame asyncOps = new InvokeAfterFrame(name, callback, delayFrame);
            asyncOps.Execute();
            return asyncOps;
        }

        public static InvokeAfterFrame Call(string name, int delayFrame, Action callback)
        {
            InvokeAfterFrame asyncOps = new InvokeAfterFrame(name, delayFrame, callback);
            asyncOps.Execute();
            return asyncOps;
        }

        public InvokeAfterFrame(Action callback) : this(callback, 1)
        {
        }

        public InvokeAfterFrame(int delayFrame, Action callback) : this(callback, delayFrame)
        {
        }

        public InvokeAfterFrame(Action callback, int delayFrame) : this("InvokeAfterFrame", callback, delayFrame)
        {
        }

        public InvokeAfterFrame(string name, int delayFrame, Action callback) : this(name, callback, delayFrame)
        {
        }

        public InvokeAfterFrame(string name, Action callback, int delayFrame)
        {
            this.name = name;
            this.delayInvokeCallback = callback;
            this.delayFrame = delayFrame;
            this.nullResultIsSuccess = true;
        }

        public override void Execute()
        {
            startFrame = Time.frameCount;
            base.Execute();
        }
        #endregion

        #region private methods
        protected override IEnumerator ExecuteCore()
        {
            while (true)
            {
                int elapsed = Time.frameCount - startFrame;
                if (elapsed >= delayFrame)
                {
                    break;
                }
                yield return null;
            }
            try
            {
                delayInvokeCallback();
            }
            catch (Exception e)
            {
                HandleException(e);
            }
        }
        #endregion
    }
}
