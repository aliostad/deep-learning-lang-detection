using System.ServiceModel;

namespace MediaVF.Common.Communication.Invocation
{
    /// <summary>
    /// Represents a service contract for communicating with an invocable service
    /// </summary>
    [ServiceContract]
    public interface IInvocableService
    {
        /// <summary>
        /// Performs an invoke with the given request, containing operation to be performed and data for the operation
        /// </summary>
        /// <param name="request">The invoke request determining what operation to perform</param>
        /// <returns>The result of the invoke, in an InvokeResponse</returns>
        [OperationContract]
        InvokeResponse Invoke(InvokeRequest request);
    }
}
