using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Onshape.Api.Client
{
    internal static class Constants
    {
        #region OAuth

        internal const string AUTH_FORM_TEMPLATE = "code={0}&client_id={1}&client_secret={2}&grant_type=authorization_code&redirect_uri={3}";
        internal const string TOKEN_URI_TEMPLATE = @"{0}/oauth/token";

        #endregion

        #region Onshape REST API URIs

        public const string DOCUMENTS_API_URI = @"/api/documents";
        public const string DOCUMENT_API_URI = @"/api/documents/{0}";

        public const string WORKSPACES_API_URI = @"/api/documents/d/{0}/workspaces";
        public const string WORKSPACE_API_URI = @"/api/documents/d/{0}/workspaces/{1}";

        public const string VERSIONS_API_URI = @"/api/documents/d/{0}/versions";
        public const string VERSION_API_URI = @"/api/documents/d/{0}/versions/{1}";

        public const string ELEMENTS_API_URI = @"/api/documents/d/{0}/{1}/{2}/elements";
        public const string ELEMENT_API_URI = @"/api/documents/d/{0}/{1}/{2}/elements?elementId={3}";

        public const string USER_API_URI = @"/api/users/{0}";

        public const string EXPORT_PARTSTUDIO_API_URI = @"/api/partstudios/d/{0}/{1}/{2}/e/{3}/{4}";
        public const string EXPORT_PART_API_URI = @"/api/parts/d/{0}/{1}/{2}/e/{3}/partid/{4}/{5}";

        public const string PURCHASES_API_URI = @"/api/accounts/purchases";
        public const string PURCHASE_API_URI = @"/api/accounts/purchases/{0}";
        public const string CONSUME_PURCHASE_API_URI = @"/api/accounts/purchases/{0}/consume";
        public const string BILLING_PLAN_API_URI = @"/api/billing/plans/{0}";
        public const string CLIENT_BILLING_PLANS_API_URI = @"/api/billing/plans/client/{0}";

        public const string ELEMENT_TRANSLATIONS_API_URI = @"/api/{0}/d/{1}/w/{2}/e/{3}/translations";
        public const string ELEMENT_TRANSLATION_FORMATS_API_URI = @"/api/{0}/d/{1}/w/{2}/e/{3}/translationformats";

        public const string CREATE_TRANSLATION_API_URI = @"/api/translations/d/{0}/w/{1}";
        public const string DOCUMENT_TRANSLATIONS_API_URI = @"/api/translations/d/{0}";
        public const string TRANSLATION_API_URI = @"/api/translations/{0}";

        public const string BLOB_ELEMENTS_API_URI = @"/api/blobelements/d/{0}/{1}/{2}";
        public const string BLOB_ELEMENT_API_URI = @"/api/blobelements/d/{0}/{1}/{2}/e/{3}";

        #endregion

        #region Misc constants

        public const string ASSEMBLIES_PATH_NAME = @"assemblies";
        public const string PARTSTUDIOS_PATH_NAME = @"partstudios";
        public const string BLOBELEMENTS_PATH_NAME = @"blobelements";

        public const string PARASOLID_FORMAT_NAME = @"parasolid";
        public const string STL_FORMAT_NAME = @"stl";

        public const int USE_API_DEFAULT = -1;

        #endregion
    }
}
