using System;
using System.Runtime.Serialization;

namespace Base.BusinessProcesses.Exceptions
{
    [Serializable]
    public class ActionInvokeException : WorkflowException
    {
        public ActionInvokeException()
        {
        }

        public ActionInvokeException(string message) : base(message)
        {
        }

        public ActionInvokeException(string message, Exception inner) : base(message, inner)
        {
        }

        protected ActionInvokeException(
            SerializationInfo info,
            StreamingContext context) : base(info, context)
        {
        }
    }
}