using Api.Spotify.Interfaces;
using Api.Spotify.Models;
using ExternalApi.Models;
using ExternalApi.Rest;

namespace Api.Spotify
{
    public class ArtistApi : ExternalApiBase, IArtistApi
    {
        public ArtistApi(IExternalApi spotifyApi):base(spotifyApi)
        {
        }

        public ApiResponse<ArtistSearchResponse> Search(string term)
        {
            var call = Rest.Method(resource: "artist.json").AddParam("q", term);
            return call.Execute<ArtistSearchResponse>();
        }
    }
}