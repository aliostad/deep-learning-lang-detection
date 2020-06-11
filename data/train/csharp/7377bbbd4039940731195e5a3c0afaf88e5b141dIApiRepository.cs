using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using MaroonVillage.Core.DomainModel;

namespace MaroonVillage.Core.Interfaces.Repositories
{
    public interface IApiRepository
    {
        IEnumerable<ApiConfig> GetApiConfigurations();
        ApiConfig GetApiConfigById(int apiConfigId);
        ApiConfig GetApiConfigByName(string apiName);
        ApiConfig GetApiConfigByKey(string apiKey);
        IEnumerable<ApiRequestInput> GetApiRequestInputsByConfigId(int apiConfigId);
    }
}
