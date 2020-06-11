using System;
using System.Runtime.Serialization;
using Zombus.MessageContracts.Exceptions;

namespace Zombus.Exceptions
{
    public class DispatchFailedException : BusException
    {
        public DispatchFailedException()
        {
        }

        public DispatchFailedException(string message) : base(message)
        {
        }

        public DispatchFailedException(string message, Exception inner) : base(message, inner)
        {
        }

        protected DispatchFailedException(SerializationInfo info, StreamingContext context) : base(info, context)
        {
        }
    }
}