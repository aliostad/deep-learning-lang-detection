using System;
using SevenDigital.Api.Schema.Charts;
using SevenDigital.Api.Schema.ParameterDefinitions.Get;

namespace SevenDigital.Api.Wrapper
{
	public static class HasChartParameterExtensions
	{
		public static IFluentApi<T> WithPeriod<T>(this IFluentApi<T> api, ChartPeriod period) where T : HasChartParameter
		{
			api.WithParameter("period", period.ToString().ToLower());
			return api;
		}

		public static IFluentApi<T> WithPeriod<T>(this IFluentApi<T> api, string period) where T : HasChartParameter
		{
			api.WithParameter("period", period.ToLower());
			return api;
		}

		public static IFluentApi<T> WithToDate<T>(this IFluentApi<T> api, DateTime toDate) where T : HasChartParameter
		{
			api.WithParameter("toDate", toDate.ToString("yyyyMMdd"));
			return api;
		}
	}
}
