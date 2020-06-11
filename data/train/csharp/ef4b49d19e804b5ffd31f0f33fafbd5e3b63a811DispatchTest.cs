using FireOnWheels.Dispatch;
using FireOnWheels.Messages;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using NServiceBus.Testing;

namespace FireOnWheels.Tests
{
    [TestClass]
    public class DispatchTest
    {
        [TestMethod]
        public void DispatchOrderHandler_SendDispatchOrderCommand_ReceiveIOrderDispatchedMessage()
        {
            Test.Initialize();
            Test.Handler(bus => new DispatchOrderHandler(bus))
                .ExpectReply<IOrderDispatchedMessage>(m => m == m)
                .OnMessage<DispatchOrderCommand>();

        }
    }
}
