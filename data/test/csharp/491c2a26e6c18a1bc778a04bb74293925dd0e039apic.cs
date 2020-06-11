using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Net;




using com.ebay.developer;
//using Service1;

using eBay.Service.Call;
using eBay.Service.Core.Sdk;
using eBay.Service.Core.Soap;
using System.Configuration;


/// <summary>
/// Summary description for apic
/// </summary>
public class apic
{
    public apic()
    {
    }
    static ApiContext apiContext = null;

   public ApiContext GetApiContext()
    {


        //ApiContext is a singleton,
        if (apiContext != null)
        {
            return apiContext;
        }

        else
        {
            apiContext = new ApiContext();

            //supply Api Server Url
            apiContext.SoapApiServerUrl = ConfigurationManager.AppSettings["Environment.ApiServerUrl"];

            //Supply user token
            ApiCredential apiCredential = new ApiCredential();

            apiCredential.eBayToken = ConfigurationManager.AppSettings["UserAccount.ApiToken"];
            apiContext.ApiCredential = apiCredential;

            //Specify site: here we use US site
            apiContext.Site = eBay.Service.Core.Soap.SiteCodeType.US;

            return apiContext;
        } // else

    } //GetApiContext

}
