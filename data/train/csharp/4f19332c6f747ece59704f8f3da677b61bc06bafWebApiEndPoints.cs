using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Carlsberg.Foundation.Models.WebApi
{
    public static class WebApiEndPoints
    {
        public static readonly Dictionary<WebApi, WebApiSettings> Endpoints = new Dictionary<WebApi, WebApiSettings>
        {
            {
                WebApi.ProductList, new WebApiSettings
                {
                    Endpoint = "/carlsberg/api/webapi/getproductlisting"
                }
            },
            {
                WebApi.PromotionList, new WebApiSettings
                {
                    Endpoint = "/carlsberg/api/webapi/getpromotionlisting"
                }
            },
            {
                WebApi.PromotionProductList, new WebApiSettings
                {
                    Endpoint = "/carlsberg/api/webapi/getpromotionproductlisting"
                }
            },
                    {
                WebApi.FavouriteList, new WebApiSettings
                {
                    Endpoint = "/carlsberg/api/webapi/getfavorites"
                }
            }
        };
    }

    public enum WebApi
    {
        ProductList,
        PromotionList,
        FavouriteList,
        PromotionProductList
    }
}

