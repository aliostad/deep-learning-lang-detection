namespace Remotus.Plugins.Spotify
{
    public static class Worker
    {
        private static bool _connected;
        public static readonly SpotifyAPI.Local.SpotifyLocalAPI LocalApi;
        public static readonly SpotifyAPI.Web.SpotifyWebAPI WebApi;

        static Worker()
        {
            LocalApi = new SpotifyAPI.Local.SpotifyLocalAPI();

            WebApi = new SpotifyAPI.Web.SpotifyWebAPI();
            WebApi.UseAuth = false;
        }


        public static bool ConnectLocalIfNotConnected()
        {
            if (!_connected)
            {
                _connected = LocalApi.Connect();
            }
            return _connected;
        }


        public static void Reset()
        {
            _connected = false;
        }



    }
}
