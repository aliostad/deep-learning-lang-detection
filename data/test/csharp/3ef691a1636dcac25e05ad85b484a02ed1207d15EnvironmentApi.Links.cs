using System;

namespace Aims.Sdk
{
    /// <summary>
    ///   Provides convenient access to the environment-specific API methods of the AIMS Platform.
    /// </summary>
    public partial class EnvironmentApi
    {
        /// <summary>
        ///   Provides convenient access to the link-related API methods of the AIMS Platform.
        /// </summary>
        public class LinksApi
        {
            private readonly EnvironmentApi _api;

            /// <summary>
            ///   Initializes a new instance of the <see cref="LinksApi"/> class.
            /// </summary>
            /// <param name="api">The API accessor.</param>
            internal LinksApi(EnvironmentApi api)
            {
                _api = api;
            }

            /// <summary>
            ///   Sends links to the API.
            /// </summary>
            /// <param name="links">The links to send.</param>
            public void Send(Link[] links)
            {
                _api.HttpHelper.Post(new Uri(_api.EnvironmentUri, "links"), links);
            }
        }
    }
}