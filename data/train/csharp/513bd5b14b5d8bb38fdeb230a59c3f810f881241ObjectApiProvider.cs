using System;
using SopraProject.Models.DatabaseInterface;
namespace SopraProject.Models.ObjectApi
{
    /// <summary>
    /// Singleton class providing access to API instances.
    /// </summary>
    public class ObjectApiProvider
    {
        #region Static
        private static ObjectApiProvider _instance;

        /// <summary>
        /// Gets the ObjectApiProvider singleton instance.
        /// </summary>
        /// <value>The instance.</value>
        public static ObjectApiProvider Instance
        {
            get 
            {
                if (_instance == null)
                    _instance = new ObjectApiProvider();
                return _instance;
            }
            private set
            { 
                _instance = new ObjectApiProvider();
            }
        }
        #endregion

        #region Properties
        public IAuthApi AuthApi { get; private set; }
        public IBookingsApi BookingsApi { get; private set; }
        public ISitesApi SitesApi { get; private set; }
        public IUserProfileAPI UserProfileApi { get; private set; }
        #endregion

        private ObjectApiProvider()
        {
            BookingsApi = new BookingsApiTestImplementation();
            AuthApi = new AuthApiTestImplementation();
            UserProfileApi = new UserProfileApi();
            SitesApi = new SitesApi();
        }
    }
}

