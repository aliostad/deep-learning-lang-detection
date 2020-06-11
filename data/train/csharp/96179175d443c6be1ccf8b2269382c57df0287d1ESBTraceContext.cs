using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ESB.Core.Monitor
{
    /// <summary>
    /// 追踪上下文
    /// </summary>
    public class ESBTraceContext
    {
        /// <summary>
        /// 追踪记录ID
        /// </summary>
        public String TraceID { get; private set; }
        /// <summary>
        /// 上一级调用的InvokeID
        /// </summary>
        public String ParentInvokeID { get; private set; }
        /// <summary>
        /// 调用层级
        /// </summary>
        public Int32 InvokeLevel { get; private set; }
        /// <summary>
        /// 调用顺序: 构造时只能初始化为0
        /// </summary>
        public Int32 InvokeOrder { get; private set; }
        /// <summary>
        /// 生成调用ID
        /// </summary>
        public String InvokeID { 
            get {
                if (InvokeLevel == 0 && String.IsNullOrEmpty(ParentInvokeID))
                {
                    return "00";
                }
                else
                {
                    return String.Format("{0}.{1}{2}", ParentInvokeID, InvokeLevel, InvokeOrder);
                }
            } 
        }

        /// <summary>
        /// 构造函数
        /// </summary>
        /// <param name="traceID"></param>
        /// <param name="invokeLevel"></param>
        /// <param name="parentInvokeID">/param>
        public ESBTraceContext(String traceID, Int32 invokeLevel, String parentInvokeID)
        {
            TraceID = traceID;
            InvokeLevel = invokeLevel;
            InvokeOrder = 0;
            ParentInvokeID = parentInvokeID;
        }

        /// <summary>
        /// 将跟踪上下文信息序列化便于传输
        /// </summary>
        /// <returns></returns>
        public override string ToString()
        {
            return String.Format("{0}:{1}:{2}", TraceID, InvokeLevel, InvokeID);
        }

        /// <summary>
        /// 增加调用的次数
        /// </summary>
        public void IncreaseInvokeOrder()
        {
            InvokeOrder++;
        }
    }
}
