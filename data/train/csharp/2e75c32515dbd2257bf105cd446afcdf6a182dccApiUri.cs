namespace Certis.EBC.ApiManager
{
    public class ApiUri
    {
        public static void SetServerBaseUri(string uri)
        {
            ApiConstants.API_SERVER_BASE_URI = uri;
        }

        public static string GetServerBaseUri()
        {
            return ApiConstants.API_SERVER_BASE_URI;
        }
        public static string GOOGLE_OBJECT_URI()
        {
            return ApiConstants.API_SERVER_BASE_URI+'/'+ApiConstants.API_GOOGLE_OBJECT_DETECTION_URI;
        }

        public static string AUTHENTICATE_URI()
        {
            return ApiConstants.API_SERVER_BASE_URI + '/' + ApiConstants.API_AUTHENTICATE_URI;
        }
    }
}
