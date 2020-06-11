using System;
using NUnit.Framework;

using Rebilly.Core;
using Rebilly.Entities;

namespace Tests.Unit.Entities
{
    [TestFixture]
    public class PayPalPaymentInstrumentUnitTests
    {
        [Test]
        public void TestConstructIsInstanceOfEntity()
        {
            var PaymentInstrument = new PayPalPaymentInstrument();
            Assert.IsInstanceOf<PayPalPaymentInstrument>(PaymentInstrument);
        }

        [Test]
        public void TestMethodIsEqualTo()
        {
            var PaymentInstrument = new PayPalPaymentInstrument();
            Assert.AreEqual("pay-pal", PaymentInstrument.Method);
        }


        [Test]
        public void TestPayPalAccountIdDefaultIsEqualTo()
        {
            var PaymentInstrument = new PayPalPaymentInstrument();
            Assert.IsNull(PaymentInstrument.PayPalAccountId);
        }

        [Test]
        public void TestPayPalAccountIdIsEqualTo()
        {
            var PaymentInstrument = new PayPalPaymentInstrument();
            PaymentInstrument.PayPalAccountId = "test2";
            Assert.AreEqual("test2", PaymentInstrument.PayPalAccountId);
        }


        [Test]
        public void TestGatewayAccountIdDefaultIsEqualTo()
        {
            var PaymentInstrument = new PayPalPaymentInstrument();
            Assert.IsNull(PaymentInstrument.GatewayAccountId);
        }

        [Test]
        public void TestGatewayAccountIdIsEqualTo()
        {
            var PaymentInstrument = new PayPalPaymentInstrument();
            PaymentInstrument.GatewayAccountId = "123123";
            Assert.AreEqual("123123", PaymentInstrument.GatewayAccountId);
        }
    }
}
