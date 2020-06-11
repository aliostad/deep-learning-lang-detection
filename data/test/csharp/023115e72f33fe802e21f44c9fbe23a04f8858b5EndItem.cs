using System;
using eBay.Service.Call;
using eBay.Service.Core.Sdk;
using eBay.Service.Core.Soap;
using eBay.Service.Util;
using System.Configuration;
using TradeManager.Models;
using System.Web;
using myTokens;

namespace TradeManager.Functions
{
    public class EndmyItem
    {
        private static ApiContext apiContext = null;
        public static void EndMyItem(string Token, string ItemID)
        {
            ApiContext apiContext = GetApiContext(Token);

            EndItemCall apiCall = new EndItemCall(apiContext);
            EndReasonCodeType Endreason = EndReasonCodeType.NotAvailable;
            apiCall.EndItem(ItemID, Endreason);
        }



        public static ApiContext GetApiContext(string Token)
        {
            //apiContext is a singleton,
            //to avoid duplicate configuration reading
            if (apiContext != null)
            {
                return apiContext;
            }
            else
            {
                apiContext = new ApiContext();
                
                //set Api Server Url
                apiContext.SoapApiServerUrl =
                    ConfigurationManager.AppSettings["Environment.ApiServerUrl"];
                //set Api Token to access eBay Api Server
                ApiCredential apiCredential = new ApiCredential();
                apiCredential.eBayToken = Token;
                apiContext.ApiCredential = apiCredential;
                //set eBay Site target to US
                apiContext.Site = SiteCodeType.US;

                //set Api logging
                apiContext.ApiLogManager = new ApiLogManager();
                apiContext.ApiLogManager.ApiLoggerList.Add(
                    new FileLogger("listing_log.txt", true, true, true)
                    );
                apiContext.ApiLogManager.EnableLogging = true;


                return apiContext;
            }
        }

    }
}