using System;
using System.Collections.Generic;
using System.Linq;
using System.ServiceModel.Channels;
using System.ServiceModel.Description;
using System.ServiceModel.Dispatcher;
using Bosphorus.ServiceModel.Hosting.Hosting.Core.Description.Endpoint.DispatchMessageInspector;

namespace Bosphorus.ServiceModel.Hosting.Hosting.Core.Description.Endpoint
{
    public class DispatchMessageInspectorBehavior : IEndpointBehavior
    {
        private readonly IDispatchMessageInspectorProvider dispatchMessageInspectorProvider;

        public DispatchMessageInspectorBehavior(IDispatchMessageInspectorProvider dispatchMessageInspectorProvider)
        {
            this.dispatchMessageInspectorProvider = dispatchMessageInspectorProvider;
        }

        public void Validate(ServiceEndpoint endpoint)
        {
        }

        public void AddBindingParameters(ServiceEndpoint endpoint, BindingParameterCollection bindingParameters)
        {
        }

        public void ApplyDispatchBehavior(ServiceEndpoint endpoint, EndpointDispatcher endpointDispatcher)
        {
            IDispatchMessageInspector dispatchMessageInspector = dispatchMessageInspectorProvider.Get(endpoint, endpointDispatcher);
            endpointDispatcher.DispatchRuntime.MessageInspectors.Add(dispatchMessageInspector);
        }

        public void ApplyClientBehavior(ServiceEndpoint endpoint, ClientRuntime clientRuntime)
        {
        }
    }
}
