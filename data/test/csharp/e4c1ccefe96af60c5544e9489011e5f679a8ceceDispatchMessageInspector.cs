using System;
using System.Collections.Generic;
using System.Linq;
using System.ServiceModel;
using System.ServiceModel.Description;
using Bosphorus.ServiceModel.Hosting.Hosting.Core.Description.Service;
using Bosphorus.ServiceModel.Hosting.Hosting.Core.Description.Service.DispatchMessageInspector;
using ServiceConfiguration = Bosphorus.ServiceModel.Hosting.Model.Configuration.ServiceConfiguration;

namespace Bosphorus.ServiceModel.Hosting.Default.Description.Service.BehaviorProvider
{
    public class DispatchMessageInspector : IServiceBehaviorProvider
    {
        private readonly IList<IDispatchMessageInspectorProvider> dispatchMessageInspectorProviders;

        public DispatchMessageInspector(IList<IDispatchMessageInspectorProvider> dispatchMessageInspectorProviders)
        {
            this.dispatchMessageInspectorProviders = dispatchMessageInspectorProviders;
        }

        public bool IsApplicable(ServiceConfiguration serviceConfiguration, Uri[] baseAddresses, ServiceHost serviceHost)
        {
            return true;
        }

        public IEnumerable<IServiceBehavior> Get(ServiceConfiguration serviceConfiguration, Uri[] baseAddresses, ServiceHost serviceHost)
        {
            IEnumerable<DispatchMessageInspectorBehavior> behaviors = dispatchMessageInspectorProviders.Select(dispatchMessageInspectorProvider => new DispatchMessageInspectorBehavior(dispatchMessageInspectorProvider));

            return behaviors;
        }
    }
}
