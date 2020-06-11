using System;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace osc.net.unittests.Message
{
    [TestClass]
    public class MessageDispatchTests
    {
        [TestMethod]
        public void MessageDispatch_Test_Dispatch()
        {
            MessageDispatch dispatch = new MessageDispatch();
            MessageBuilder builder1 = new MessageBuilder();
            builder1.SetAddress("/test1");
            builder1.PushAtom(1);

            MessageBuilder builder2 = new MessageBuilder();
            builder2.SetAddress("/test2");
            builder2.PushAtom("TEST");

            MessageBuilder builder3 = new MessageBuilder();
            builder3.SetAddress("/test3");
            builder3.PushAtom("TEST2");

            String address = "";
            Atom value = new Atom();

            Action<osc.net.Message> callback = m => {
                address = m.Address;
                value = m.Atoms[0];
            };

            dispatch.RegisterMethod("/test1", callback);
            dispatch.RegisterMethod("/test2", callback);

            // Test
            dispatch.Dispatch(builder1.ToMessage());
            Assert.AreEqual("/test1", address);
            Assert.AreEqual(1, value);

            dispatch.Dispatch(builder2.ToMessage());
            Assert.AreEqual("/test2", address);
            Assert.AreEqual("TEST", value);

            // No callback registered, values should not be set
            dispatch.Dispatch(builder3.ToMessage());
            Assert.AreNotEqual("/test3", address);
            Assert.AreNotEqual("TEST2", value);
        }
    }
}
