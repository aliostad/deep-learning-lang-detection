using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace Cocon90.Lib.Util.Time
{
    /// <summary>
    /// 多任务连续执行类
    /// </summary>
    public class sequenceInvoker
    {
        /// <summary>
        /// 同步执行action，并使用异步依次执行invkeFinish
        /// </summary>
        /// <param name="action"></param>
        /// <param name="invokeFinish"></param>
        public static void InvokeSequence(Action action, params Action[] invokeFinish)
        {
            if (action != null) { action(); }
            intervalInvoker.Invoke(1, ((invokeFinish != null && invokeFinish.Length > 0) ? invokeFinish.Length : 0), false, (count) =>
            {
                invokeFinish[count - 1]();
            });
        }

        /// <summary>
        /// 异步执行action，并使用异步依次执行invkeFinish 
        /// </summary>
        /// <param name="action"></param>
        /// <param name="invokeFinish"></param>
        public static void InvokeSequenceAsnync(Action action, params Action[] invokeFinish)
        {
            if (action != null) { action.BeginInvoke(null, null); }
            intervalInvoker.Invoke(1, ((invokeFinish != null && invokeFinish.Length > 0) ? invokeFinish.Length : 0), false, (count) =>
            {
                invokeFinish[count - 1].BeginInvoke(null, null);
            });
        }
    }
}
