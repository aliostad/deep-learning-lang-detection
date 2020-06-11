using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GoogleApi1
{
    public class ApiMethods
    {
        public Code.Api api { get; private set; }
        public bool IsAuthenticated { get { return api.Authentification.IsAuthenticated; } }
        public string AuthenticationResponse { get { return api.Authentification.AuthenticationResponse; } }

        public ApiMethods() //ref Client.cs Metods = new ApiMethods();
        {
            api = new Code.Api();
            AuthenticateApi();
        }

        private bool AuthenticateApi()
        {
            api.Authentification = new Code.Authentification();
            api.Authentification.Authenticate();
            return api.Authentification.IsAuthenticated;
        }
    }
}
