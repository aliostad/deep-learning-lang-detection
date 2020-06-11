using NUnit.Framework;
using Rebilly.Entities;

namespace Tests.Unit.Entities
{
    [TestFixture]
    public class PaymentTokenInstrumentUnitTests
    {
        [Test]
        public void TestConstructIsInstanceOfEntity()
        {
            var CurrentPaymentInstrument = new PaymentTokenInstrument();
            Assert.IsInstanceOf<PaymentTokenInstrument>(CurrentPaymentInstrument);
        }


        [Test]
        public void TestPanDefaultIsEqualTo()
        {
            var CurrentPaymentInstrument = new PaymentTokenInstrument();
            Assert.IsNull(CurrentPaymentInstrument.Pan);
        }


        [Test]
        public void TestPanIsEqualTo()
        {
            var CurrentPaymentInstrument = new PaymentTokenInstrument();
            CurrentPaymentInstrument.Pan = "Pan1";
            Assert.AreEqual("Pan1", CurrentPaymentInstrument.Pan);
        }


        [Test]
        public void TestExpMonthDefaultIsEqualTo()
        {
            var CurrentPaymentInstrument = new PaymentTokenInstrument();
            Assert.AreEqual(0,CurrentPaymentInstrument.ExpMonth);
        }


        [Test]
        public void TestExpMonthIsEqualTo()
        {
            var CurrentPaymentInstrument = new PaymentTokenInstrument();
            CurrentPaymentInstrument.ExpMonth = 3;
            Assert.AreEqual(3, CurrentPaymentInstrument.ExpMonth);
        }


        [Test]
        public void TestExpYearDefaultIsEqualTo()
        {
            var CurrentPaymentInstrument = new PaymentTokenInstrument();
            Assert.AreEqual(0, CurrentPaymentInstrument.ExpYear);
        }


        [Test]
        public void TestExpYearIsEqualTo()
        {
            var CurrentPaymentInstrument = new PaymentTokenInstrument();
            CurrentPaymentInstrument.ExpYear = 2018;
            Assert.AreEqual(2018, CurrentPaymentInstrument.ExpYear);
        }


        [Test]
        public void TestCvvDefaultIsEqualTo()
        {
            var CurrentPaymentInstrument = new PaymentTokenInstrument();
            Assert.IsNull(CurrentPaymentInstrument.Cvv);
        }


        [Test]
        public void TestCvvIsEqualTo()
        {
            var CurrentPaymentInstrument = new PaymentTokenInstrument();
            CurrentPaymentInstrument.Cvv = "Cvv1";
            Assert.AreEqual("Cvv1", CurrentPaymentInstrument.Cvv);
        }


        [Test]
        public void TestRoutingNumberDefaultIsEqualTo()
        {
            var CurrentPaymentInstrument = new PaymentTokenInstrument();
            Assert.AreEqual(0, CurrentPaymentInstrument.RoutingNumber);
        }


        [Test]
        public void TestRoutingNumberIsEqualTo()
        {
            var CurrentPaymentInstrument = new PaymentTokenInstrument();
            CurrentPaymentInstrument.RoutingNumber = 2018;
            Assert.AreEqual(2018, CurrentPaymentInstrument.RoutingNumber);
        }


        [Test]
        public void TestAccountNumberDefaultIsEqualTo()
        {
            var CurrentPaymentInstrument = new PaymentTokenInstrument();
            Assert.AreEqual(0, CurrentPaymentInstrument.AccountNumber);
        }


        [Test]
        public void TestAccountNumberIsEqualTo()
        {
            var CurrentPaymentInstrument = new PaymentTokenInstrument();
            CurrentPaymentInstrument.AccountNumber = 2018;
            Assert.AreEqual(2018, CurrentPaymentInstrument.AccountNumber);
        }


        [Test]
        public void TestAccountTypeDefaultIsEqualTo()
        {
            var CurrentPaymentInstrument = new PaymentTokenInstrument();
            Assert.IsNull(CurrentPaymentInstrument.AccountType);
        }


        [Test]
        public void TestAccountTypeIsEqualTo()
        {
            var CurrentPaymentInstrument = new PaymentTokenInstrument();
            CurrentPaymentInstrument.AccountType = "AccountType1";
            Assert.AreEqual("AccountType1", CurrentPaymentInstrument.AccountType);
        }


        [Test]
        public void TestBankNameDefaultIsEqualTo()
        {
            var CurrentPaymentInstrument = new PaymentTokenInstrument();
            Assert.IsNull(CurrentPaymentInstrument.BankName);
        }


        [Test]
        public void TestBankNameIsEqualTo()
        {
            var CurrentPaymentInstrument = new PaymentTokenInstrument();
            CurrentPaymentInstrument.BankName = "BankName1";
            Assert.AreEqual("BankName1", CurrentPaymentInstrument.BankName);
        }
    }
}
