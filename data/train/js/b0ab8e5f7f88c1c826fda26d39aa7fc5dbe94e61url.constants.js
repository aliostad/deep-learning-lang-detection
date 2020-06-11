// Constants for the API Endpoints.
(function (API, undefined) {

    // URL Constants
    API.URL_CONSTANTS = {
        COUNTRIES: {
            GET: "/umbraco/Api/CheckoutApi/GetCountries",
            GET_ALL: "/umbraco/Api/CheckoutApi/GetAllCountries"
        },
        ORDER: {
            PLACE: "/umbraco/Api/CheckoutApi/PlaceOrder",
            GET_PREORDER_SUMMARY: "/umbraco/Api/CheckoutApi/PreOrderSummary",
            GET_SUMMARY: "/umbraco/Api/CheckoutApi/PrepareSale",
            SAVE_BILLING: "/umbraco/Api/CheckoutApi/SaveBillingAddress"
        },
        PAYMENT_METHODS: {
            GET: "/umbraco/Api/CheckoutApi/GetPaymentMethods"
        },
        PROVINCES: {
            GET: "/umbraco/Api/CheckoutApi/GetProvinces",
            GET_ALL: "/umbraco/Api/CheckoutApi/GetAllProvinces"
        },
        SHIPPING_METHODS: {
            GET_QUOTES: "/umbraco/Api/CheckoutApi/GetShippingMethodQuotes",
            SAVE_RATE: "/umbraco/Api/CheckoutApi/SaveShippingRateQuote",
            SAVE_SHIPPING: "/umbraco/Api/CheckoutApi/SaveShippingAddress"
        }
    };

}(window.checkout.API = window.checkout.API || {}));