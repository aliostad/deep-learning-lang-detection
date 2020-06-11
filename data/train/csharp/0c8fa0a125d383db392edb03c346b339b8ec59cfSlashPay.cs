using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace SlashPay
{
    public class SlashPay
    {
        protected string ApiUrl = "http://localhost:1337/"; // https://api.slash.us.com/
        protected string ApiVersion = "v1";
        protected string PublicKey = "";
        protected string PrivateKey = "";
        protected Request.RequestGateway Request = null;
        protected Api.CheckoutApi checkoutApi = null;
        protected Api.RedirectApi redirectApi = null;
        protected Api.SubscriptionApi subscriptionApi = null;
        protected Api.MessagingApi messagingApi = null;

        public SlashPay(string publicKey, string privateKey)
        {
            this.PublicKey = publicKey;
            this.PrivateKey = privateKey;
            this.Request = new Request.RequestGateway(ApiUrl + ApiVersion + '/');
            this.checkoutApi = new Api.CheckoutApi(this.PrivateKey, this.Request);
            this.redirectApi = new Api.RedirectApi(this.PrivateKey, this.Request);
            this.subscriptionApi = new Api.SubscriptionApi(this.PrivateKey, this.Request);
            this.messagingApi = new Api.MessagingApi(this.PrivateKey, this.Request);
        }

        /// Checkout API
        /// API Class
        /// 
        public Api.CheckoutApi CheckoutApi
        {
            get
            {
                return this.checkoutApi;
            }
        }

        /// Redirect API
        /// API Class
        /// 
        public Api.RedirectApi RedirectApi
        {
            get {
                return this.redirectApi;
            }
        }

        /// Subscription API
        /// API Class
        /// 
        public Api.SubscriptionApi SubscriptionApi
        {
            get
            {
                return this.subscriptionApi;
            }
        }

        /// Messaging API
        /// API Class
        /// 
        public Api.MessagingApi MessagingApi
        {
            get
            {
                return this.messagingApi;
            }
        }

    }
}
