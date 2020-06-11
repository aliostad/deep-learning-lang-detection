#region usings

using ASC.Api.Interfaces;

#endregion

namespace ASC.Api.Impl
{
    internal class ApiConfiguration : IApiConfiguration
    {
        public ApiConfiguration()
        {
            ApiPrefix = "api";
            ApiVersion = "1.0";
            ApiSeparator = '/';
        }

        #region IApiConfiguration Members

        public string ApiPrefix { get; set; }
        public string ApiVersion { get; set; }
        public char ApiSeparator { get; set; }

        public string GetBasePath()
        {
            return (ApiPrefix + ApiSeparator + ApiVersion + ApiSeparator).TrimStart('/', '~');
        }

        public uint ItemsPerPage
        {
            get { return 25; }
        }

        #endregion
    }
}