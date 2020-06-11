using System;

namespace NetPackCreator.Controllers
{
    /// <summary></summary>
    internal sealed class SourceGroup
    {
        /// <summary></summary>
        private readonly INetworkInterfaceController _interfaceController;
        /// <summary></summary>
        private readonly IPhysicalAddressController _physicalAddressController;
        /// <summary></summary>
        private readonly ISourceIpAddressController _sourceIpAddressController;
        /// <summary></summary>
        private readonly IPortController _portController;

        /// <summary></summary>
        /// <param name="interfaceController"></param>
        /// <param name="physicalAddressController"></param>
        /// <param name="sourceIpAddressController"></param>
        /// <param name="portController"></param>
        public SourceGroup(INetworkInterfaceController interfaceController, IPhysicalAddressController physicalAddressController, ISourceIpAddressController sourceIpAddressController, IPortController portController)
        {
            if (interfaceController == null) throw new ArgumentNullException("interfaceController");
            if (physicalAddressController == null) throw new ArgumentNullException("physicalAddressController");
            if (sourceIpAddressController == null) throw new ArgumentNullException("sourceIpAddressController");
            if (portController == null) throw new ArgumentNullException("portController");

            this._interfaceController = interfaceController;
            this._physicalAddressController = physicalAddressController;
            this._sourceIpAddressController = sourceIpAddressController;
            this._portController = portController;
        }

        /// <summary></summary>
        public INetworkInterfaceController InterfaceController { get { return this._interfaceController; } }

        /// <summary></summary>
        public IPhysicalAddressController PhysicalAddressController { get { return this._physicalAddressController; } }

        /// <summary></summary>
        public ISourceIpAddressController SourceIpAddressController { get { return this._sourceIpAddressController; } }

        /// <summary></summary>
        public IPortController PortController { get { return this._portController; } }
    }
}