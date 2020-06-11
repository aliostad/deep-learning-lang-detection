using System;
using NSubstitute;

namespace PSAppHarbor.Tests
{
    class SubstituteApiScope : IDisposable
    {
        private readonly Func<IAppHarborApi> _originalApi;

        public SubstituteApiScope()
        {
            _originalApi = ApiProvider.Instance.GetApi;
            Api = Substitute.For<IAppHarborApi>();
            ApiProvider.Instance.GetApi = () => Api;
        }

        public IAppHarborApi Api { get; set; }

        public void Dispose()
        {
            ApiProvider.Instance.GetApi = _originalApi;
        }
    }
}