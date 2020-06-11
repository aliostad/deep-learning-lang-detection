using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Http;
using RoCMS.Base.ForWeb.Models;

namespace Shop.Web
{
    public static class WebApiConfig
    {
        public static void Register(HttpConfiguration config)
        {
            WebApiConfigHelper.ApiRoute(config.Routes, "shop/countries/get", "ManufacturerApi", "GetCountries");

            WebApiConfigHelper.ApiRoute(config.Routes, "shop/categories/get", "CategoryApi", "GetCategories");
            WebApiConfigHelper.ApiRoute(config.Routes, "shop/categories/order/update", "CategoryApi", "UpdateSortOrder");


            WebApiConfigHelper.ApiRoute(config.Routes, "shop/category/create", "CategoryApi", "Create");
            WebApiConfigHelper.ApiRoute(config.Routes, "shop/category/update", "CategoryApi", "Update");
            WebApiConfigHelper.ApiRoute(config.Routes, "shop/category/{categoryId}/delete", "CategoryApi", "Remove");

            WebApiConfigHelper.ApiRoute(config.Routes, "shop/manufacturers/get", "ManufacturerApi", "GetManufacturers");
            WebApiConfigHelper.ApiRoute(config.Routes, "shop/manufacturers/used/get", "ManufacturerApi", "GetUsedManufacturers");
            WebApiConfigHelper.ApiRoute(config.Routes, "shop/manufacturer/create", "ManufacturerApi", "Create");
            WebApiConfigHelper.ApiRoute(config.Routes, "shop/manufacturer/update", "ManufacturerApi", "Update");
            WebApiConfigHelper.ApiRoute(config.Routes, "shop/manufacturer/{manufacturerId}/delete", "ManufacturerApi", "Delete");

            WebApiConfigHelper.ApiRoute(config.Routes, "shop/suppliers/get", "ManufacturerApi", "GetSuppliers");

            WebApiConfigHelper.ApiRoute(config.Routes, "shop/packs/get", "PackApi", "GetPacks");
            WebApiConfigHelper.ApiRoute(config.Routes, "shop/pack/create", "PackApi", "Create");
            WebApiConfigHelper.ApiRoute(config.Routes, "shop/pack/update", "PackApi", "Update");
            WebApiConfigHelper.ApiRoute(config.Routes, "shop/pack/{packId}/delete", "PackApi", "Delete");
            WebApiConfigHelper.ApiRoute(config.Routes, "shop/pack/{packId}/get", "PackApi", "Get");

            WebApiConfigHelper.ApiRoute(config.Routes, "shop/compatibles/get", "CompatibleApi", "GetCompatibleSets");
            WebApiConfigHelper.ApiRoute(config.Routes, "shop/compatible/create", "CompatibleApi", "Create");
            WebApiConfigHelper.ApiRoute(config.Routes, "shop/compatible/update", "CompatibleApi", "Update");
            WebApiConfigHelper.ApiRoute(config.Routes, "shop/compatible/{compatibleSetId}/delete", "CompatibleApi", "Delete");
            WebApiConfigHelper.ApiRoute(config.Routes, "shop/compatible/{compatibleSetId}/get", "CompatibleApi", "Get");

            WebApiConfigHelper.ApiRoute(config.Routes, "shop/actions/get", "ActionApi", "GetActions");
            WebApiConfigHelper.ApiRoute(config.Routes, "shop/action/{actionId}/get", "ActionApi", "Get");
            WebApiConfigHelper.ApiRoute(config.Routes, "shop/action/create", "ActionApi", "Create");
            WebApiConfigHelper.ApiRoute(config.Routes, "shop/action/update", "ActionApi", "Update");
            WebApiConfigHelper.ApiRoute(config.Routes, "shop/action/{actionId}/delete", "ActionApi", "Delete");

            WebApiConfigHelper.ApiRoute(config.Routes, "shop/goods/category/{categoryId}/get", "GoodsApi", "GetCategory");
            WebApiConfigHelper.ApiRoute(config.Routes, "shop/goods/filter", "GoodsApi", "GetGoods");
            WebApiConfigHelper.ApiRoute(config.Routes, "shop/goods/get", "GoodsApi", "Get");
            WebApiConfigHelper.ApiRoute(config.Routes, "shop/goods/create", "GoodsApi", "Create");
            WebApiConfigHelper.ApiRoute(config.Routes, "shop/goods/update", "GoodsApi", "Update");
            WebApiConfigHelper.ApiRoute(config.Routes, "shop/goods/{goodsId}/delete", "GoodsApi", "Delete");

            WebApiConfigHelper.ApiRoute(config.Routes, "shop/goods/reviews/get", "GoodsApi", "GetAllGoodsReviews");
            WebApiConfigHelper.ApiRoute(config.Routes, "shop/goods/reviews/{goodsId}/get", "GoodsApi", "GetGoodsReviews");
            WebApiConfigHelper.ApiRoute(config.Routes, "shop/goods/textreviews/get", "GoodsApi", "GetAllGoodsReviewsWithText");
            WebApiConfigHelper.ApiRoute(config.Routes, "shop/goods/textreviews/{goodsId}/get", "GoodsApi", "GetGoodsReviewsWithText");
            WebApiConfigHelper.ApiRoute(config.Routes, "shop/goods/reviews/create", "GoodsApi", "CreateGoodsReview");
            WebApiConfigHelper.ApiRoute(config.Routes, "shop/goods/reviews/update", "GoodsApi", "UpdateGoodsReview");
            WebApiConfigHelper.ApiRoute(config.Routes, "shop/goods/reviews/{reviewId}/delete", "GoodsApi", "DeleteGoodsReview");
            WebApiConfigHelper.ApiRoute(config.Routes, "shop/goods/reviews/{reviewId}/accept", "GoodsApi", "AcceptReview");
            WebApiConfigHelper.ApiRoute(config.Routes, "shop/goods/reviews/{reviewId}/hide", "GoodsApi", "HideReview");

            WebApiConfigHelper.ApiRoute(config.Routes, "shop/goods/awaiting/create", "GoodsAwaitingApi", "Create");

            WebApiConfigHelper.ApiRoute(config.Routes, "shop/orders/get", "OrderApi", "GetOrders");
            WebApiConfigHelper.ApiRoute(config.Routes, "shop/orders/page/{startIndex}/{pageSize}/{clientId}/get", "OrderApi", "GetOrdersPage");
            WebApiConfigHelper.ApiRoute(config.Routes, "shop/order/create", "OrderApi", "Create");
            WebApiConfigHelper.ApiRoute(config.Routes, "shop/order/update", "OrderApi", "Update");
            WebApiConfigHelper.ApiRoute(config.Routes, "shop/order/updateState", "OrderApi", "UpdateState");
            WebApiConfigHelper.ApiRoute(config.Routes, "shop/order/{orderId}/delete", "OrderApi", "Delete");


            WebApiConfigHelper.ApiRoute(config.Routes, "shop/specs/get", "SpecApi", "GetSpecs");
            WebApiConfigHelper.ApiRoute(config.Routes, "shop/spec/create", "SpecApi", "Create");
            WebApiConfigHelper.ApiRoute(config.Routes, "shop/spec/update", "SpecApi", "Update");
            WebApiConfigHelper.ApiRoute(config.Routes, "shop/spec/updateorder", "SpecApi", "UpdateOrder");
            WebApiConfigHelper.ApiRoute(config.Routes, "shop/spec/{specId}/delete", "SpecApi", "Delete");

            WebApiConfigHelper.ApiRoute(config.Routes, "shop/pickupPoints/get", "PickUpPointApi", "GetPoints");
            WebApiConfigHelper.ApiRoute(config.Routes, "shop/pickupPoint/create", "PickUpPointApi", "Create");
            WebApiConfigHelper.ApiRoute(config.Routes, "shop/pickupPoint/update", "PickUpPointApi", "Update");
            WebApiConfigHelper.ApiRoute(config.Routes, "shop/pickupPoint/{id}/delete", "PickUpPointApi", "Delete");

            WebApiConfigHelper.ApiRoute(config.Routes, "shop/regularClients/get", "RegularClientApi", "Get");
            WebApiConfigHelper.ApiRoute(config.Routes, "shop/regularClients/create", "RegularClientApi", "Create");
            WebApiConfigHelper.ApiRoute(config.Routes, "shop/regularClients/update", "RegularClientApi", "Update");
            WebApiConfigHelper.ApiRoute(config.Routes, "shop/regularClients/{id}/delete", "RegularClientApi", "Delete");

            WebApiConfigHelper.ApiRoute(config.Routes, "shop/cart/{goodsId}/{packId}/{count}/add", "CartApi", "AddItem", true);
            WebApiConfigHelper.ApiRoute(config.Routes, "shop/cart/{goodsId}/{packId}/{count}/change", "CartApi", "ChangeItemCount", true);
            WebApiConfigHelper.ApiRoute(config.Routes, "shop/cart/{goodsId}/{packId}/remove", "CartApi", "RemoveItem", true);
            WebApiConfigHelper.ApiRoute(config.Routes, "shop/cart/clear", "CartApi", "Clear", true);
            WebApiConfigHelper.ApiRoute(config.Routes, "shop/cart/summary", "CartApi", "CartSummary", true);
            WebApiConfigHelper.ApiRoute(config.Routes, "shop/cart/get", "CartApi", "GetCart", true);
            WebApiConfigHelper.ApiRoute(config.Routes, "shop/cart/process", "CartApi", "ProcessOrder", true);
            WebApiConfigHelper.ApiRoute(config.Routes, "shop/cart/user/discount/update", "CartApi", "UpdateUserDiscount", true);


            WebApiConfigHelper.ApiRoute(config.Routes, "shop/dimensions/get", "DimensionApi", "GetDimensions");

            WebApiConfigHelper.ApiRoute(config.Routes, "shop/export/yml/generate", "ExportYmlApi", "Generate");
            WebApiConfigHelper.ApiRoute(config.Routes, "shop/export/yml/tasks", "ExportYmlApi", "Tasks");
            WebApiConfigHelper.ApiRoute(config.Routes, "shop/export/yml/settings/get", "ExportYmlApi", "Settings");

            WebApiConfigHelper.ApiRoute(config.Routes, "shop/export/file/yml", "ExportYmlApi", "GetYmlFile");

            WebApiConfigHelper.ApiRoute(config.Routes, "shop/export/prices/start", "ExportShopDbApi", "Start");
            WebApiConfigHelper.ApiRoute(config.Routes, "shop/export/prices/tasks", "ExportShopDbApi", "Tasks");

            WebApiConfigHelper.ApiRoute(config.Routes, "shop/clients/page/{startIndex}/{pageSize}/get", "ClientApi", "GetClientsPage");
            WebApiConfigHelper.ApiRoute(config.Routes, "shop/client/update", "ClientApi", "Update");
            WebApiConfigHelper.ApiRoute(config.Routes, "shop/client/{clientId}/get", "ClientApi", "Get");
            WebApiConfigHelper.ApiRoute(config.Routes, "shop/client/{clientId}/delete", "ClientApi", "DeleteClient");
            WebApiConfigHelper.ApiRoute(config.Routes, "shop/client/user/{userId}/get", "ClientApi", "GetForUser");


            WebApiConfigHelper.ApiRoute(config.Routes, "shop/settings/get", "ShopSettingsApi", "Get");
            WebApiConfigHelper.ApiRoute(config.Routes, "shop/settings/update", "ShopSettingsApi", "Update");


            WebApiConfigHelper.ApiRoute(config.Routes, "shop/mass/price/tasks", "MassChangeApi", "GetChangePriceTasks");
            WebApiConfigHelper.ApiRoute(config.Routes, "shop/mass/price/change", "MassChangeApi", "ChangePrice");


            WebApiConfigHelper.ApiRoute(config.Routes, "shop/currency/{currencyId}/delete", "CurrencyApi", "DeleteCurrency");
            WebApiConfigHelper.ApiRoute(config.Routes, "shop/currencies/get", "CurrencyApi", "GetCurrencies");
            WebApiConfigHelper.ApiRoute(config.Routes, "shop/currency/create", "CurrencyApi", "CreateCurrency");
            WebApiConfigHelper.ApiRoute(config.Routes, "shop/currency/update", "CurrencyApi", "UpdateCurrency");
            WebApiConfigHelper.ApiRoute(config.Routes, "shop/currency/setdefault/{id}", "CurrencyApi", "SetDefaultCurrency");
        }
    }
}
