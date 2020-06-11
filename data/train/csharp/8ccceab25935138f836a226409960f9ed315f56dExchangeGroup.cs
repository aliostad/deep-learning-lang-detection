using System;

namespace NetPackCreator.Controllers
{
    /// <summary></summary>
    internal sealed class ExchangeGroup
    {
        /// <summary></summary>
        private readonly IConnectionModeController _connectionModeController;
        /// <summary></summary>
        private readonly IConnectionStateController _connectionStateController;
        /// <summary></summary>
        private readonly ICommandController _sendCommandController;
        /// <summary></summary>
        private readonly IWriteController _writeController;
        /// <summary></summary>
        private readonly IExchangeViewController _exchangeViewController;

        /// <summary></summary>
        /// <param name="connectionModeController"></param>
        /// <param name="connectionStateController"></param>
        /// <param name="sendCommandController"></param>
        /// <param name="writeController"></param>
        /// <param name="exchangeViewController"></param>
        public ExchangeGroup(IConnectionModeController connectionModeController, IConnectionStateController connectionStateController, ICommandController sendCommandController,
            IWriteController writeController, IExchangeViewController exchangeViewController)
        {
            if (connectionModeController == null) throw new ArgumentNullException("connectionModeController");
            if (connectionStateController == null) throw new ArgumentNullException("connectionStateController");
            if (sendCommandController == null) throw new ArgumentNullException("sendCommandController");
            if (writeController == null) throw new ArgumentNullException("writeController");
            if (exchangeViewController == null) throw new ArgumentNullException("exchangeViewController");

            this._connectionModeController = connectionModeController;
            this._connectionStateController = connectionStateController;
            this._sendCommandController = sendCommandController;
            this._writeController = writeController;
            this._exchangeViewController = exchangeViewController;
        }

        /// <summary></summary>
        public IConnectionModeController ConnectionModeController { get { return this._connectionModeController; } }

        /// <summary></summary>
        public IConnectionStateController ConnectionStateController { get { return this._connectionStateController; } }

        /// <summary></summary>
        public ICommandController SendCommandController { get { return this._sendCommandController; } }

        /// <summary></summary>
        public IWriteController WriteController { get { return this._writeController; } }

        /// <summary></summary>
        public IExchangeViewController ExchangeViewController { get { return this._exchangeViewController; } }
    }
}