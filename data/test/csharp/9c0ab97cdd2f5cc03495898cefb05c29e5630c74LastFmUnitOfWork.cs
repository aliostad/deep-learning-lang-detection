using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using SteamWebAPI2;
using SteamWebAPI2.Interfaces;
using IF.Lastfm.Core.Api;

namespace PersonalWebsiteApi.UnitsOfWork
{
    public class LastFmUnitOfWork : IDisposable
    {
        private LastfmClient _lastfmClient;
        private ChartApi _chartApi;
        private TrackApi _trackApi;
        private AlbumApi _albumApi;
        private ArtistApi _artistApi;
        private UserApi _userApi;
        private string _apiKey { get; set; }
        private string _apiSecret { get; set; }
        
        #region Constructor
        public LastFmUnitOfWork(string apiKey, string apiSecret)
        {
            _apiKey = apiKey;
            _apiSecret = apiSecret;
            this._lastfmClient = new LastfmClient(_apiKey, _apiSecret);
        }
        #endregion
        public IChartApi LastFmChartRepository()
        {
            if (this._chartApi == null)
            {
                this._chartApi = _lastfmClient.Chart;
            }
            return _chartApi;
        }
        public ITrackApi LastFmTrackRepository()
        {
            if (this._trackApi == null)
            {
                this._trackApi = _lastfmClient.Track;
            }
            return _trackApi;
        }
        public IAlbumApi LastFmAlbumRepository()
        {
            if (this._albumApi == null)
            {
                this._albumApi = _lastfmClient.Album;
            }
            return _albumApi;
        }

        public IUserApi LastFmUserRepository()
        {
            if (this._userApi == null)
            {
                this._userApi = _lastfmClient.User;
            }
            return _userApi;
        }
        public IArtistApi LastFmArtistRepository()
        {
            if (this._artistApi == null)
            {
                this._artistApi = _lastfmClient.Artist;
            }
            return _artistApi;
        }
     

        void IDisposable.Dispose()
        {

        }
        
    }
}
