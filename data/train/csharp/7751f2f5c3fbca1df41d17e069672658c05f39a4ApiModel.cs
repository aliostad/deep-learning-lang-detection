using Core;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace NancyApplication1.Models
{
    public class ApiModel : BaseModel
    {
        public Guid Id { get; set; }
        public string Path { get; set; }

        public ApiModel()
        {

        }

        public ApiModel(Api api)
        {
            this.Id = api.Id;
            this.Path = api.Path;
            this.QtdResources = api.Resources.Count;
        }

        public static explicit operator Api(ApiModel model)
        {
            return new Api(model);
        }

        public static explicit operator ApiModel(Api domain)
        {
            return new ApiModel(domain);
        }

        public static IEnumerable<ApiModel> TodosComQuantidade(IQueryable<Api> query)
        {
            return query.ToList().Select(s => (ApiModel)s);
        }

        public int QtdResources { get; set; }
    }
}
