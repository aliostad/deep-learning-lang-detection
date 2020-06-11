using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace BSAG.IOCTalk.Common.Interface.Communication
{
    /// <summary>
    /// Defines the message types
    /// </summary>
    public enum MessageType
    {
        /// <summary>
        /// Undefined
        /// </summary>
        Undefined = 0,

        /// <summary>
        /// Method invoke request without caller blocking
        /// Specified by the <see cref="RemoteInvokeBehaviourAttribute"/>
        /// </summary>
        AsyncMethodInvokeRequest = 9,

        /// <summary>
        /// Method invoke request
        /// </summary>
        MethodInvokeRequest = 10,

        /// <summary>
        /// Method invoke response
        /// </summary>
        MethodInvokeResponse = 11,

        /// <summary>
        /// Exception occured
        /// </summary>
        Exception = 12,
    }
}
