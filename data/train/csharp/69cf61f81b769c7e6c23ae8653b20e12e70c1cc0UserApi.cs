using IO.Swagger.Api;

namespace Timeskip.API
{
    public class UserApi
    {
        #region shizzle
        private static UsersApi userApi;
        #endregion

        #region Constructor
        private UserApi() { }
        #endregion

        #region Get instance
        public static UsersApi GetUserApi()
        {
            if(userApi==null)
            {
                userApi = new UsersApi(ApiConfig.GetConfig());
            }

            return userApi;
        }
        #endregion
    }
}
