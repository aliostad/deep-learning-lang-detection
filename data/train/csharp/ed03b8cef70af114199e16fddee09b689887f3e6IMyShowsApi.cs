using MyShows.Core.WebApi.Response;
using System.Collections.Generic;
using ApiModels = MyShows.Core.Services.IMyShowsWebApi.Response.Models;

namespace MyShows.Core.Services.IMyShowsWebApi
{
    public interface IMyShowsApi
    {
        void SetCookiesSessionID(string sessionId);
        WebApiResponse<ApiModels.Base.BaseModel> SignIn(string name, string password);
        WebApiResponse<ApiModels.Profile> GetProfile();
        WebApiResponse<Dictionary<string, ApiModels.Shows>> GetMyShows();
        WebApiResponse<Dictionary<string, ApiModels.Shows>> GetNextEpisodes();
        WebApiResponse<List<ApiModels.Shows>> GetAllShowsWithFavorites();
        WebApiResponse<Dictionary<string, List<ApiModels.News>>> GetNews();
    }
}
