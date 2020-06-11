using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace MaroonVillage.Core.DomainModel
{
    public interface IApiRequest
    {
        ApiConfig _ApiConfig { get; set; }
        IEnumerable<ApiRequestInput> ApiRequestInputs { get; set; }
    }
    public class ApiRequest
    {

        public ApiConfig _ApiConfig { get; set; }
        public IEnumerable<ApiRequestInput> ApiRequestInputs { get; set; }

        public ApiRequest()
        {
            
        }
    }
}
