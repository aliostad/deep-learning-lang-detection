namespace BingImageSearch
{
    public class BingApi
    {
        private readonly string _api;

        public BingApi(string api)
        {
            _api = api;
        }

        public override string ToString()
        {
            return _api.ToString();
        }

        public static implicit operator string(BingApi api)
        {
            return api == null ? null : api.ToString();
        }

        public static implicit operator BingApi(string api)
        {
            return new BingApi(api);
        }
    }
}