using MongoDB.Bson.Serialization.Attributes;

namespace Quantae.DataModel
{
    [BsonKnownTypes()]
    public abstract class PaymentInstrumentInfo
    {
    }

    public class NullPaymentInstrumentInfo : PaymentInstrumentInfo
    {
    }

    public class CreditCardPaymentInstrumentInfo : PaymentInstrumentInfo
    {
        public PaymentInstrument CardType { get; set; }
        public string OtherInfo { get; set; }
    }

    public class PaypalInstrumentInfo : PaymentInstrumentInfo
    {
        public string PaypalInfo { get; set; }
    }

    public class AmazonCheckoutInstrumentInfo : PaymentInstrumentInfo
    {
        public string AmazonCheckoutInfo { get; set; }
    }

    public class GoogleCheckoutInstrumentInfo : PaymentInstrumentInfo
    {
        public string GoogleCheckoutInfo { get; set; }
    }
}