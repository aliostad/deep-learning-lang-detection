using System;
using NUnit.Framework;

using Rebilly.Core;
using Rebilly.Entities;

namespace Tests.Unit.Entities
{
    [TestFixture]
    public class CashPaymentInstrumentUnitTests
    {
        [Test]
        public void TestConstructIsInstanceOfEntity()
        {
            var PaymentInstrument = new CashPaymentInstrument();
            Assert.IsInstanceOf<CashPaymentInstrument>(PaymentInstrument);
        }

        [Test]
        public void TestMethodIsEqualTo()
        {
            var PaymentInstrument = new CashPaymentInstrument();
            Assert.AreEqual("cash", PaymentInstrument.Method);
        }


        [Test]
        public void TestReceivedByDefaultIsEqualTo()
        {
            var PaymentInstrument = new CashPaymentInstrument();
            Assert.IsNull(PaymentInstrument.ReceivedBy);
        }

       

        [Test]
        public void TestReceivedByIsEqualTo()
        {
            var PaymentInstrument = new CashPaymentInstrument();
            PaymentInstrument.ReceivedBy = "test2";
            Assert.AreEqual("test2", PaymentInstrument.ReceivedBy);
        }
    }
}
