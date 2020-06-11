using AutoMapper;
using IdentityServer4.MongoDBDriver.Entities;
using System.Collections.Generic;

namespace IdentityServer4.MongoDBDriver.Mappers
{
    public static class ApiResourceMappers
    {
        static ApiResourceMappers()
        {
            Mapper = new MapperConfiguration(cfg => {
                cfg.AddProfile<ApiResourceProfile>();
                cfg.AddProfile<ScopeMapperProfile>();
                cfg.AddProfile<SecretMapperProfile>();
            }).CreateMapper();
        }

        internal static IMapper Mapper { get; }

        public static Models.ApiResource ToModel(this ApiResource apiResource)
        {
            return apiResource == null ? null : Mapper.Map<Models.ApiResource>(apiResource);
        }

        public static List<Models.ApiResource> ToModel(this IEnumerable<ApiResource> apiResources)
        {
            return apiResources == null ? null : Mapper.Map<List<Models.ApiResource>>(apiResources);
        }

        public static ApiResource ToEntity(this Models.ApiResource apiResource)
        {
            return apiResource == null ? null : Mapper.Map<ApiResource>(apiResource);
        }

        public static List<ApiResource> ToEntity(this IEnumerable<Models.ApiResource> apiResources)
        {
            return apiResources == null ? null : Mapper.Map<List<ApiResource>>(apiResources);
        }
    }
}
