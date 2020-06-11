using System;
using NUnit.Framework;

using Rebilly.Core;
using Rebilly.Entities;

namespace Tests.Unit.Entities
{
    [TestFixture]
    public class PaymentCardPaymentInstrumentUnitTests
    {
        [Test]
        public void TestConstructIsInstanceOfEntity()
        {
            var PaymentInstrument = new PaymentCardPaymentInstrument();
            Assert.IsInstanceOf<PaymentCardPaymentInstrument>(PaymentInstrument);
        }


        [Test]
        public void TestMethodIsEqualTo()
        {
            var PaymentInstrument = new PaymentCardPaymentInstrument();
            Assert.AreEqual("payment-card", PaymentInstrument.Method);
        }

        [Test]
        public void TestPaymentCardIdDefaultIsEqualTo()
        {
            var PaymentInstrument = new PaymentCardPaymentInstrument();
            Assert.IsNull(PaymentInstrument.PaymentCardId);
        }

        [Test]
        public void TestPaymentCardIdIsEqualTo()
        {
            var PaymentInstrument = new PaymentCardPaymentInstrument();
            PaymentInstrument.PaymentCardId = "test2";
            Assert.AreEqual("test2", PaymentInstrument.PaymentCardId);
        }


        [Test]
        public void TestGatewayAccountIdDefaultIsEqualTo()
        {
            var PaymentInstrument = new PaymentCardPaymentInstrument();
            Assert.IsNull(PaymentInstrument.GatewayAccountId);
        }

        [Test]
        public void TestGatewayAccountIdIsEqualTo()
        {
            var PaymentInstrument = new PaymentCardPaymentInstrument();
            PaymentInstrument.GatewayAccountId = "123123";
            Assert.AreEqual("123123", PaymentInstrument.GatewayAccountId);
        }
    }
}
