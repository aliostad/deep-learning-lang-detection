using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace API_MobileUser
{
    public static class Constants
    {
        public static readonly string BASE_API = "http://apidevelopment-inclass01.azurewebsites.net/";
        public static readonly string REGISTER_API = BASE_API + "api/Account/Register";
        public static readonly string LOGIN_API = BASE_API + "Token";
        public static readonly string USER_PROFILE_API = BASE_API + "api/Account/UserInfo";
        public static readonly string CHANGE_PASSWORD_API = BASE_API + "api/Account/ChangePassword";
        public static readonly string UPDATE_PROFILE_API = BASE_API + "api/Account/UpdateProfile";
        public static readonly string LOGOUT_PROFILE_API = BASE_API + "api/Account/Logout";       

    }

    
}
