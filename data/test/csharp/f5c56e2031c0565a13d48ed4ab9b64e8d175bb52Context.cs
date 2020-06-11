namespace Selfnet.Tests
{
    internal static class Context
    {
        private static SelfossApi api;

        public static ConnectionOptions Options = new ConnectionOptions
        {
            Host = "nostromo.myds.me",
            Base = "selfoss",
            Username = "gleroi",
            Password = "cXVa2I0L"
        };

        public static readonly HttpGatewayFake Http = new HttpGatewayFake();

        public static SelfossApi Api()
        {
            if (api == null)
            {
                //api = new SelfossApi(Options, Http);
                api = new SelfossApi(Options);
            }
            return api;
        }
    }
}