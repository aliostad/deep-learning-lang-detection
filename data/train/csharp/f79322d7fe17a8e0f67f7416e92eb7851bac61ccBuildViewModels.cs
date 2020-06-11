using ManagerDomain.Models.Dbs;
using ManagerDomain.Models.ViewModels;
using PositivoDigital.Web.MVC.Extensions;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UserBusiness.Logics;

namespace ManagerBusiness.Logics.Builds
{
    public class BuildViewModels
    {
        public static IList<ApiKeyViewModel> ApiKeys(IList<ApiKey> apiKeysDb)
        {
            var apiKeysViewModel = new List<ApiKeyViewModel>();
            foreach (var apiKey in apiKeysDb)
            {
                var apiKeyUrls = ApiKeyUrls(apiKey.Urls.ToList());
                var apiKeyViewModel = new ApiKeyViewModel(apiKey.Id, apiKey.Name, apiKey.Base64Secret, apiKey.UserId, 
                    apiKeyUrls);

                apiKeysViewModel.Add(apiKeyViewModel);
            }

            return apiKeysViewModel;
        }

        //public static ApiKeyViewModel ApiKey(ApiKey apiKey)
        //{
        //    var apiKeyUrls = ApiKeyUrls(apiKey.Urls.ToList());
        //    var result = new ApiKeyViewModel(apiKey.Id, apiKey.Name, apiKey.Base64Secret, apiKeyUrls);
        //
        //    return result;
        //}

        public static IList<ApiKeyUrlViewModel> ApiKeyUrls(IList<ApiKeyUrl> apiKeyUrls)
        {
            var result = new List<ApiKeyUrlViewModel>();

            foreach (var apiKeyUrl in apiKeyUrls)
            {
                var apiKeyViewModel = new ApiKeyUrlViewModel(apiKeyUrl.Url);
                result.Add(apiKeyViewModel);
            }
            return result;
        }
	}
}
