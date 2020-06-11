using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace WeConnect.Core
{
    public static class ApiClientExtension
    {
        public static Task ExecuteAsync(this IApiClient client, Func<ApiDescriptionBuilder, ApiDescriptionBuilder> builder)
        {
            var apiDescription = BuildApiDescription(builder);
            return client.ExecuteAsync(apiDescription);
        }

        public static Task<T> ExecuteAndGetResultAsync<T>(this IApiClient client, Func<ApiDescriptionBuilder, ApiDescriptionBuilder> builder)
        {
            var apiDescription = BuildApiDescription(builder);
            return client.ExecuteAndGetResultAsync<T>(apiDescription);
        }

        public static Task<FileDescription> ExecuteAndGetFileAsync(this IApiClient client, Func<ApiDescriptionBuilder, ApiDescriptionBuilder> builder)
        {
            var apiDescription = BuildApiDescription(builder);
            return client.ExecuteAndGetFileAsync(apiDescription);
        }

        private static ApiDescription BuildApiDescription(Func<ApiDescriptionBuilder, ApiDescriptionBuilder> builder)
        {
            var apiDescriptionbuilder = new ApiDescriptionBuilder();
            var apiDescription = builder(apiDescriptionbuilder).Build();

            return apiDescription;
        }
    }
}
