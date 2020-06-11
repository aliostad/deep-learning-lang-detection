using System.Collections.Generic;
using Api.SoundCloud.Interfaces;
using Api.Spotify.Interfaces;
using Api.iTunes.Interfaces;
using Youtube.Api;

namespace Gateway
{
    public class ExternalApiGateway: Interfaces.IExternalApiGateway
    {
        private readonly IITunesApi _iTunesApi;
        private readonly ISoundCloudApi _soundCloudApi;
        private readonly ISpotifyApi _spotifyApi;
        private readonly IYoutubeApi _youtubeApi;

        public ExternalApiGateway(
            IITunesApi iTunesApi, 
            ISoundCloudApi soundCloudApi,
            ISpotifyApi spotifyApi,
            IYoutubeApi youtubeApi)
        {
            _iTunesApi = iTunesApi;
            _soundCloudApi = soundCloudApi;
            _spotifyApi = spotifyApi;
            _youtubeApi = youtubeApi;
        }

        public List<ExternalApiUser> SearchExternalApis(string term)
        {
            return null;
        }
    }
}