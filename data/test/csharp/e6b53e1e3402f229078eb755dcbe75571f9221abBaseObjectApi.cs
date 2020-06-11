using System;

namespace Cdiscount.Alm.Sonar.Api.Wrapper.Business
{
    /// <summary>
    /// Interface of the sonar base object
    /// </summary>
    public interface IBaseObjectApi
    {
        void SetSonarApiClient(SonarApiClient client);
    }

    /// <summary>
    /// Represents a base object of the Sonar API 
    /// </summary>
    /// <typeparam name="T"></typeparam>
    public class BaseObjectApi<T> : IBaseObjectApi where T : IBaseObjectApi, new()
    {
        private SonarApiClient _sonarApiClient;

        /// <summary>
        /// Client of the sonar API
        /// </summary>
        protected SonarApiClient SonarApiClient { get { return _sonarApiClient; } }

        /// <summary>
        /// Create a sonar base object
        /// </summary>
        /// <param name="sonarApiClient"></param>
        /// <returns></returns>
        public static T CreateObject(SonarApiClient sonarApiClient)
        {
            T result = new T();
            result.SetSonarApiClient(sonarApiClient);
            return result;
        }

        /// <summary>
        /// Set the sonar API client to the object
        /// </summary>
        /// <param name="client"></param>
        void IBaseObjectApi.SetSonarApiClient(SonarApiClient client)
        {
            _sonarApiClient = client;
        }
    }
}