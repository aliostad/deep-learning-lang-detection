using System.Linq;
using Xero.Api.Core;
using Xero.Api.Core.Model;

namespace XeroTestJob.Tests
{
    public class ApiWrapperTest
    {
        private XeroCoreApi _api;

        protected XeroCoreApi Api
        {
            get { return _api ?? (_api = CreateCoreApi()); }
        }

        private static XeroCoreApi CreateCoreApi()
        {
            return new Xero.Api.Example.Applications.Private.Core
            {
                UserAgent = "Xero Api - Integration tests"
            };
        }
    }
}
