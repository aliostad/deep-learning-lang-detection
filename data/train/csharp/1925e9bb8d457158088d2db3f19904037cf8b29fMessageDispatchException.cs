using NetFusion.Base.Exceptions;
using NetFusion.Common;
using NetFusion.Messaging.Core;
using System;
using System.Collections.Generic;
using System.Linq;

#if NET461
using System.Runtime.Serialization;
#endif

namespace NetFusion.Messaging
{
    /// <summary>
    /// An exception that is thrown when there is an exception dispatching a message.
    /// </summary>
#if NET461
    [Serializable]
#endif
    public class MessageDispatchException : NetFusionException
    {
        public MessageDispatchException() { }

        /// <summary>
        /// Dispatch exception.
        /// </summary>
        /// <param name="message">Dispatch error message.</param>
        public MessageDispatchException(string message): 
            base(message) { }

        /// <summary>
        /// Dispatch Exception.
        /// </summary>
        /// <param name="message">Dispatch error message.</param>
        /// <param name="innerException">The source exception.  If the exception is derived
        /// from NetFusionException, the details will be added to this exception's details.</param>
        public MessageDispatchException(string message, Exception innerException) :
            base(message, innerException) { }

        /// <summary>
        /// Dispatch Exception.
        /// </summary>
        /// <param name="message">Dispatch error message.</param>
        /// <param name="dispatchInfo">Describes how the message is to be dispatched when published.</param>
        /// <param name="innerException">The source exception.  If the exception is derived from 
        /// NetFusionException, the detail will be added to this exception's details.</param>
        public MessageDispatchException(string message, MessageDispatchInfo dispatchInfo, Exception innerException)
            : base(message, innerException)
        {
            Check.NotNull(dispatchInfo, nameof(dispatchInfo));

            Details["DispatchInfo"] = new
            {
                MessageType = dispatchInfo.MessageType.FullName,
                ConsumerType = dispatchInfo.ConsumerType.FullName,
                HandlerMethod = dispatchInfo.MessageHandlerMethod.Name
            };
        }

        /// <summary>
        /// Dispatch Exception.
        /// </summary>
        /// <param name="errorMessage">Dispatch error message.</param>
        /// <param name="message">The message being dispatched.</param> when dispatching the message.</param>
        public MessageDispatchException(string errorMessage, IEnumerable<MessageDispatchException> dispatchExceptions) 
            : base(errorMessage)
        {
            Check.NotNull(dispatchExceptions, nameof(dispatchExceptions));

            Details = new Dictionary<string, object>
            {
                { "DispatchExceptions", dispatchExceptions.Select(de => de.Details).ToArray() }
            };
        }
    }
}
