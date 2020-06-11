using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MVC.Models
{
    public class Api
    {
        public string ApiNumber { get; set; }
        public string ApiDescription { get; set; }
    }


    public static class ApiDetails
    {
        private static List<Api> _apiDetail { get; set; }

        static ApiDetails()
        {
            _apiDetail = new List<Api>();
            _apiDetail.Add(new Api { ApiNumber = "601", ApiDescription = "Description of 601" });
            _apiDetail.Add(new Api { ApiNumber = "602", ApiDescription = "Description of 602" });
        }

        public static Api Get(string api)
        {
            return _apiDetail.Where(k => k.ApiNumber == api).FirstOrDefault();
        }

    }
}
