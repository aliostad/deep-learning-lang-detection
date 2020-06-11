using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;

namespace Vision.Api.Common.Document
{
    public class ApiAttributeDocumentProvider : IApiDocumentProvider
    {
        /// <summary>
        /// get all Api Document Categories in the assembly
        /// </summary>
        /// <param name="assembly"></param>
        /// <param name="includingApiDetail"></param>
        /// <returns></returns>
        public IEnumerable<ApiDocumentApiCategory> GetAllCategories(Assembly assembly)
        {
            var categoriesInAssembly = new List<ApiDocumentApiCategory>();
            var apiCategoryAttributes = assembly.GetCustomAttributes<ApiCategoryAttribute>();
            foreach (var apiCategoryAttribute in apiCategoryAttributes)
            {
                var apiCategory = new ApiDocumentApiCategory()
                {
                    Name = apiCategoryAttribute.Name,
                    DisplayName = apiCategoryAttribute.DisplayName,
                    Description = apiCategoryAttribute.Description,
                    IsDefault = apiCategoryAttribute.IsDefault,
                    Apis = new List<ApiDocumentApi>()
                };

                categoriesInAssembly.Add(apiCategory);
            }
            if (!categoriesInAssembly.Any())
                return categoriesInAssembly;

            var defaultApiCategory = categoriesInAssembly.FirstOrDefault(c => c.IsDefault) ?? categoriesInAssembly.FirstOrDefault();

            var apiInfoAttributesInAssembly = GetApiNameAttribtues(assembly);

            if (apiInfoAttributesInAssembly.Any())
            {
                foreach (var apiInfo in apiInfoAttributesInAssembly)
                {
                    if (apiInfo.Item1 == null || apiInfo.Item2 == null || apiInfo.Item3 == null)
                        continue;

                    var category = categoriesInAssembly.FirstOrDefault(c => c.Name.Equals(apiInfo.Item3.Category)) ?? defaultApiCategory;
                    if (category != null)
                    {
                        var api = new ApiDocumentApi
                        {
                            Name = apiInfo.Item3.ApiName,
                            DisplayName = apiInfo.Item3.DisplayName,
                            Description = apiInfo.Item3.Description,
                            Parameters = new List<ApiDocumentApiParameter>()
                        };

                        // Api Parameters
                        var propertyInfos = apiInfo.Item1.GetProperties(BindingFlags.Instance | BindingFlags.Public | BindingFlags.GetProperty | BindingFlags.SetProperty);
                        foreach (var propertyInfo in propertyInfos)
                        {
                            var apiParameterAttr = propertyInfo.GetCustomAttribute<ApiRequestParameterAttribute>();
                            if (apiParameterAttr != null)
                            {
                                api.Parameters.Add(new ApiDocumentApiParameter
                                {
                                    Name = propertyInfo.Name,
                                    DisplayName = apiParameterAttr.DisplayName,
                                    Description = apiParameterAttr.Description
                                });
                            }
                        }

                        // Api Result
                        var apiResponseAttr = apiInfo.Item2.GetCustomAttribute<ApiResponseAttribute>();

                        api.Result = new ApiDocumentApiResult
                        {
                            Name = apiInfo.Item2.FullName,
                            DisplayName = apiResponseAttr != null ? apiResponseAttr.DisplayName : apiInfo.Item2.Name,
                            Description = apiResponseAttr != null ? apiResponseAttr.Description : apiInfo.Item2.Name,
                            Fields = new List<ApiDocumentApiResultField>()
                        };

                        var allResultPropertyInfos = apiInfo.Item2.GetProperties(BindingFlags.Instance | BindingFlags.Public | BindingFlags.GetProperty | BindingFlags.SetProperty);
                        foreach (var propertyInfo in allResultPropertyInfos)
                        {
                            var apiResponsePropertyAttr = propertyInfo.GetCustomAttribute<ApiResponsePropertyAttribute>();
                            if (apiResponsePropertyAttr != null)
                            {
                                api.Result.Fields.Add(new ApiDocumentApiResultField
                                {
                                    Name = propertyInfo.Name,
                                    DisplayName = apiResponsePropertyAttr.DisplayName,
                                    Description = apiResponsePropertyAttr.Description
                                });
                            }
                        }

                        category.Apis.Add(api);
                    }
                }
            }

            return categoriesInAssembly;
        }

        protected List<Tuple<Type, Type, ApiNameAttribute>> GetApiNameAttribtues(Assembly assembly)
        {
            var result = new List<Tuple<Type, Type, ApiNameAttribute>>();

            var apiRequestBaseType = typeof(ApiRequest);
            var apiRequestTypes = assembly.GetTypes().Where(c => apiRequestBaseType.IsAssignableFrom(c));
            var apiResponseBaseType = typeof(IApiResponse);
            var apiResponseTypes = assembly.GetTypes().Where(c => apiResponseBaseType.IsAssignableFrom(c));
            foreach (var apiRequestType in apiRequestTypes)
            { 
                var apiNameAttr = apiRequestType.GetCustomAttribute<ApiNameAttribute>();
                if (apiNameAttr != null)
                {
                    var apiResponseType = apiResponseTypes.Where(c => c.BaseType != null && c.BaseType.IsGenericType && c.BaseType.GetGenericArguments().Length == 1 && c.BaseType.GetGenericArguments().First() == apiRequestType).FirstOrDefault();

                    if (apiResponseType != null)
                    {
                        result.Add(Tuple.Create<Type, Type, ApiNameAttribute>(apiRequestType, apiResponseType, apiNameAttr));
                    }
                }
            }

            return result;
        }
    }
}
