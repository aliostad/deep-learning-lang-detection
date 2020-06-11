using System.Globalization;
using SevenDigital.Api.Schema.ParameterDefinitions.Get;

namespace SevenDigital.Api.Wrapper
{
	public static class HasUserDeliverItemParameterExtensions
	{
		public static IFluentApi<T> WithEmailAddress<T>(this IFluentApi<T> api, string emailAddress) where T : HasUserDeliverItemParameter
		{
			api.WithParameter("emailAddress", emailAddress);
			return api;
		}

		public static IFluentApi<T> WithTransactionId<T>(this IFluentApi<T> api, string transactionId) where T : HasUserDeliverItemParameter
		{
			api.WithParameter("transactionId", transactionId);
			return api;
		}

		public static IFluentApi<T> WithRetailPrice<T>(this IFluentApi<T> api, decimal retailPrice) where T : HasUserDeliverItemParameter
		{
			api.WithParameter("retailPrice", retailPrice);
			return api;
		}
	}
}