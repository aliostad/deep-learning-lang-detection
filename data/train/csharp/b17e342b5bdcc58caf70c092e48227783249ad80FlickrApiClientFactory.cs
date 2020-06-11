using System.Configuration;
using FlickrApi = FlickrNet.Flickr;

namespace Flickr.Api.Client
{
	public sealed class FlickrApiClientFactory : IFlickrApiClientFactory
	{
		private const string ApiKeySettingsKey = "FlickrApiKey";
		private const string ApiSecretSettingsKey = "FlickrApiSecret";

		 public IFlickrApiClient Create()
		 {
			 var apiKey = ConfigurationManager.AppSettings[ApiKeySettingsKey];
			 var apiSecret = ConfigurationManager.AppSettings[ApiSecretSettingsKey];
			 var flicrApi = new FlickrApi(apiKey, apiSecret);

			 return new FlickrApiClient(flicrApi);
		 }
	}
}