using System;
using NUnit.Framework;

using Rebilly.Core;
using Rebilly.Entities;

namespace Tests.Unit.Entities
{
    [TestFixture]
    public class AchPaymentInstrumentUnitTests
    {
        [Test]
        public void TestConstructIsInstanceOfEntity()
        {
            var PaymentInstrument = new AchPaymentInstrument();
            Assert.IsInstanceOf<AchPaymentInstrument>(PaymentInstrument);
        }


        [Test]
        public void TestMethodIsEqualTo()
        {
            var PaymentInstrument = new AchPaymentInstrument();
            Assert.AreEqual("ach", PaymentInstrument.Method);
        }

        [Test]
        public void TestBankAccountIdDefaultIsEqualTo()
        {
            var PaymentInstrument = new AchPaymentInstrument();
            Assert.IsNull(PaymentInstrument.BankAccountId);
        }

        [Test]
        public void TestBankAccountIdIsEqualTo()
        {
            var PaymentInstrument = new AchPaymentInstrument();
            PaymentInstrument.BankAccountId = "test2";
            Assert.AreEqual("test2", PaymentInstrument.BankAccountId);
        }


        [Test]
        public void TestGatewayAccountIdDefaultIsEqualTo()
        {
            var PaymentInstrument = new AchPaymentInstrument();
            Assert.IsNull(PaymentInstrument.GatewayAccountId);
        }

        [Test]
        public void TestGatewayAccountIdIsEqualTo()
        {
            var PaymentInstrument = new AchPaymentInstrument();
            PaymentInstrument.GatewayAccountId = "123123";
            Assert.AreEqual("123123", PaymentInstrument.GatewayAccountId);
        }
    }
}
