using System;
using Famoser.FrameworkEssentials.Services.Interfaces;
using Famoser.SyncApi.Models;
using Famoser.SyncApi.Models.Interfaces;
using Famoser.SyncApi.Repositories;
using Famoser.SyncApi.Repositories.Interfaces;
using Famoser.SyncApi.Services;
using Famoser.SyncApi.Services.Interfaces;
using Famoser.SyncApi.Services.Interfaces.Authentication;

namespace Famoser.SyncApi.Helpers
{
    public class SyncApiHelper : IDisposable
    {
        private readonly IStorageService _storageService;
        private readonly string _applicationName;
        private readonly string _uri;
        public SyncApiHelper(IStorageService storageService, string applicationName, string uri = "https://public.syncapi.famoser.ch")
        {
            _storageService = storageService;
            _applicationName = applicationName;
            _uri = uri;
        }

        private IApiConfigurationService _apiConfigurationService;
        public IApiConfigurationService ApiConfigurationService
        {
            get { return _apiConfigurationService ?? (_apiConfigurationService = new ApiConfigurationService(_applicationName, _uri)); }
            set { _apiConfigurationService = value; }
        }

        private IApiStorageService _apiStorageService;
        public IApiStorageService ApiStorageService
        {
            get { return _apiStorageService ?? (_apiStorageService = new ApiStorageService(_storageService, ApiConfigurationService)); }
            set { _apiStorageService = value; }
        }

        private IApiTraceService _apiTraceService;
        public IApiTraceService ApiTraceService
        {
            get { return _apiTraceService ?? (_apiTraceService = new ApiTraceService()); }
            set { _apiTraceService = value; }
        }

        private IApiAuthenticationService _apiAuthenticationService;
        public IApiAuthenticationService ApiAuthenticationService
        {
            get { return _apiAuthenticationService ?? (_apiAuthenticationService = new ApiAuthenticationService(ApiConfigurationService, ApiUserRepository, ApiDeviceRepository)); }
            set { _apiAuthenticationService = value; }
        }

        private IApiUserRepository<UserModel> _apiUserRepository;
        public IApiUserRepository<UserModel> ApiUserRepository
        {
            get { return _apiUserRepository ?? (_apiUserRepository = new ApiUserRepository<UserModel>(ApiConfigurationService, ApiStorageService, ApiTraceService)); }
            set { _apiUserRepository = value; }
        }

        private IApiDeviceRepository<DeviceModel> _apiDeviceRepository;
        public IApiDeviceRepository<DeviceModel> ApiDeviceRepository
        {
            get { return _apiDeviceRepository ?? (_apiDeviceRepository = new ApiDeviceRepository<DeviceModel>(ApiConfigurationService, ApiStorageService, ApiTraceService)); }
            set { _apiDeviceRepository = value; }
        }

        private IApiCollectionRepository<CollectionModel> _apiCollectionRepository;
        public IApiCollectionRepository<CollectionModel> ApiCollectionRepository
        {
            get { return _apiCollectionRepository ?? (_apiCollectionRepository = new ApiCollectionRepository<CollectionModel>(ApiAuthenticationService, ApiStorageService, ApiConfigurationService, ApiTraceService)); }
            set { _apiCollectionRepository = value; }
        }


        public ApiRepository<T, CollectionModel> ResolveRepository<T>()
            where T : ISyncModel
        {
            return new ApiRepository<T, CollectionModel>(ApiCollectionRepository, ApiConfigurationService, ApiStorageService, ApiAuthenticationService, ApiTraceService);
        }

        private bool _isDisposed;
        protected virtual void Dispose(bool disposing)
        {
            if (!_isDisposed)
                if (disposing)
                {
                    ApiUserRepository.Dispose();
                    ApiDeviceRepository.Dispose();
                    ApiCollectionRepository.Dispose();
                }
            _isDisposed = true;
        }

        public void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }
    }
}
