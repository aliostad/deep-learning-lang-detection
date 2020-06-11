using Cdiscount.TFS.Api.Business;
using System;
using System.Collections.Generic;
using System.Text;

namespace Cdiscount.TFS.Api
{
    public interface IBaseObjectApi
    {
        void SetTfsApiClient(TfsApiClient client);
    }

    /// <summary>
    /// Represents a base object of the Tfs API 
    /// </summary>
    /// <typeparam name="T"></typeparam>
    public class BaseObjectApi<T> : IBaseObjectApi where T : IBaseObjectApi, new()
    {
        private TfsApiClient _tfsApiClient;

        /// <summary>
        /// Client of the sonar API
        /// </summary>
        protected TfsApiClient TfsApiClient { get { return _tfsApiClient; } }

        /// <summary>
        /// Create a sonar base object
        /// </summary>
        /// <param name="sonarApiClient"></param>
        /// <returns></returns>
        public static T CreateObject(TfsApiClient tfsApiClient)
        {
            T result = new T();
            result.SetTfsApiClient(tfsApiClient);
            return result;
        }

        /// <summary>
        /// Set the sonar API client to the object
        /// </summary>
        /// <param name="client"></param>
        void IBaseObjectApi.SetTfsApiClient(TfsApiClient client)
        {
            _tfsApiClient = client;
        }
    }
}
