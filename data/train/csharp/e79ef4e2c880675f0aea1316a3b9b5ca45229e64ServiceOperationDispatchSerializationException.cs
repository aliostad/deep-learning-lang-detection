using EnterSentials.Framework.Properties;
using System;
using System.Runtime.Serialization;

namespace EnterSentials.Framework
{
    [Serializable]
    public class ServiceOperationDispatchSerializationException : Exception
    {
        public ServiceOperationDispatchSerializationException() : this(Resources.ServiceOperationDispatchSerializationErrorMessage) { }
        public ServiceOperationDispatchSerializationException(string message) : base(message) { }
        public ServiceOperationDispatchSerializationException(string message, Exception inner) : base(message, inner) { }
        protected ServiceOperationDispatchSerializationException(SerializationInfo info, StreamingContext context) : base(info, context) { }
    }
}