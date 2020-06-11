using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Klarna.Api;

namespace Klarna.Checkout.Euro.KlarnaApi
{
    public class KlarnaApiImpl : IKlarnaApi
    {
        private readonly Api.Api _klarnaApi;

        public KlarnaApiImpl(Api.Api klarnaApi)
        {
            _klarnaApi = klarnaApi;
        }

        public ActivateReservationResponse Activate(string s)
        {
            return _klarnaApi.Activate(s);
        }

        public bool CancelReservation(string s)
        {
            return _klarnaApi.CancelReservation(s);
        }

        public string CreditInvoice(string s)
        {
            return _klarnaApi.CreditInvoice(s);
        }
    }
}