using System;
using System.Collections.Generic;
using System.Text;

namespace CommerceBuilder.Payments
{
    /// <summary>
    /// Enumeration that represents a payment instrument type.
    /// </summary>
    public enum PaymentInstrument : short
    {
        /// <summary>
        /// Payment instrument is unknown.
        /// </summary>
        Unknown = 0,

        /// <summary>
        /// Payment instrument is a visa credit card.
        /// </summary>
        Visa = 1,

        /// <summary>
        /// Payment instrument is a MasterCard credit card.
        /// </summary>
        MasterCard = 2,

        /// <summary>
        /// Payment instrument is a Discover credit card.
        /// </summary>
        Discover = 3,

        /// <summary>
        /// Payment instrument is a AmericanExpress credit card.
        /// </summary>
        AmericanExpress = 4,

        /// <summary>
        /// Payment instrument is a JCB credit card.
        /// </summary>
        JCB = 5,

        /// <summary>
        /// Payment instrument is a Maestro credit card.
        /// </summary>
        Maestro = 6,

        /// <summary>
        /// Payment instrument is PayPal.
        /// </summary>
        PayPal = 7,

        /// <summary>
        /// Payment instrument is a Purchase Order.
        /// </summary>
        PurchaseOrder = 8,

        /// <summary>
        /// Payment instrument is a Check.
        /// </summary>
        Check = 9,

        /// <summary>
        /// Payment instrument is a Mail Order.
        /// </summary>
        Mail = 10,

        /// <summary>
        /// Payment instrument is GoogleCheckout.
        /// </summary>
        GoogleCheckout = 11,

        /// <summary>
        /// Payment instrument is a Gift Certificate.
        /// </summary>
        GiftCertificate = 12,

        /// <summary>
        /// Payment instrument is a Phone Call.
        /// </summary>
        PhoneCall = 13,

        /// <summary>
        /// Payment instrument is UK Maestro, Switch, or Solo
        /// </summary>
        SwitchSolo = 14,
            
        /// <summary>
        /// Payment instrument is Visa Debit, Delta, or Electron
        /// </summary>
        VisaDebit = 15, 

        /// <summary>
        /// Payment instrument is Diner's Club
        /// </summary>
        DinersClub = 16,

        /// <summary>
        /// Payment instrument is another Credit Card
        /// </summary>
        CreditCard = 17 
    }
}
