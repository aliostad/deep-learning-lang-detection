using System.Collections.Generic;
using System.Threading.Tasks;
using ApiGateway.Domain.Caching;
using ApiGateway.Domain.Models;
using ApiGateway.Domain.Repositories;

namespace ApiGateway.Domain.Services
{
    public class ApiService
    {
        private readonly IApiRepository _apiRepository;
        private readonly IApiCachingProvider _apiCachingProvider;

        public ApiService(IApiCachingProvider apiCachingProvider, IApiRepository apiRepository)
        {
            _apiCachingProvider = apiCachingProvider;
            _apiRepository = apiRepository;
        }

        public async Task<IEnumerable<Api>> Get()
        {
            return await _apiRepository.Get();
        }

        public async Task<Api> GetFromCache(string apiName)
        {
            return await _apiCachingProvider.Get(apiName);
        }

        public async Task Load()
        {
            var apis = await _apiRepository.GetWithAccountsAndServices();
            await _apiCachingProvider.Load(apis);
        }

        public async Task Create(Api api, int[] serviceIds)
        {
            await _apiRepository.Create(api, serviceIds);
            await _apiCachingProvider.Add(api, serviceIds);
        }

        public async Task Update(int id, Api api, int[] serviceIds)
        {
            var old = await Get(id);
            await _apiRepository.Update(id, api, serviceIds);
            await _apiCachingProvider.Update(old.RelativePath, api, serviceIds);
        }

        public async Task Delete(int id)
        {
            var api = await Get(id);
            await _apiRepository.Delete(api);
            await _apiCachingProvider.Delete(api.RelativePath);
        }

        public async Task<Api> Get(int id)
        {
            return await _apiRepository.Get(id);
        }

        public async Task<IEnumerable<Api>> Get(int[] ids)
        {
            return await _apiRepository.Get(ids);
        }

        public async Task<IEnumerable<Api>> Search(string query)
        {
            return await _apiRepository.Search(query);
        }
    }
}
