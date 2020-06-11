using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ApiFox.Models
{
    public class MyApiDto
    {
        public MyApiDto()
        { }
        public MyApiDto(Apis api)
        {
            this.ApiId = api.Id;
            this.ApiName = api.ApiName;
            this.ApiUrl = api.ApiUrl;
        }
        public int ApiId { get; set; }
        public string ApiName { get; set; }
        public string ApiUrl { get; set; }

        public Apis ToEntity()
        {
            return new Apis
                {
                    ApiName = this.ApiName,
                    ApiUrl = this.ApiUrl
                };
        }
    }
}
