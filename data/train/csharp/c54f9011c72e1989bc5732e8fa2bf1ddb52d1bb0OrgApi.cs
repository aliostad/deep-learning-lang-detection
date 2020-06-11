using IO.Swagger.Api;

namespace Timeskip.API
{
    public class OrgApi
    {
        private static OrganizationsApi organisationAPi;

        private OrgApi() { }

        public static OrganizationsApi GetOrgApi()
        {
            if(organisationAPi == null)
            {
                organisationAPi = new OrganizationsApi(ApiConfig.GetConfig());
            }

            return organisationAPi;
        }

        public static void AddTokenToHeader(string token)
        {
            if (organisationAPi == null)
                GetOrgApi();
            organisationAPi.Configuration.AddDefaultHeader("Authorization", "Bearer " + token);
        }
    }
}
