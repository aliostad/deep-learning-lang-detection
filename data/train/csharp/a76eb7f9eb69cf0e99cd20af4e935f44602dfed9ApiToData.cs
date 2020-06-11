using System.Web.Configuration;
using FProj.Data;

namespace FProj.Api
{
    public static class ApiToData
    {
        public static Film FilmApiToData(FilmApi filmApi)
        {
            return new Film() {
                Description = filmApi.Description,
                Director = filmApi.Director,
                Duration = filmApi.Duration,
                Id = filmApi.Id,
                PremiereDate = filmApi.PremiereDate,
                Rate = filmApi.Rate,
                Title = filmApi.Title,
                DateCreated = filmApi.DateCreated,
                UserIdCreator = filmApi.User.Id               
            };
        }

        public static Image ImageApiToData(ImageApi imageApi, int filmId, bool isPoster = false)
        {
            return new Image() {
                FilmId = filmId,
                IsPoster = isPoster,
                Id = imageApi.Id,
                Name = imageApi.Path?.Replace(WebConfigurationManager.AppSettings["ImageFolder"], "")
            };
        }

        public static Actor ActorApiToData(ActorApi actorApi)
        {
            return new Actor()
            {
                FirstName = actorApi.FirstName,
                Id = actorApi.Id,
                LastName = actorApi.LastName
            };
        }

        public static Genre GenreApiToData(GenreApi genreApi)
        {
            return new Genre()
            {
                Description = genreApi.Description,
                Id = genreApi.Id,
                Title = genreApi.Title
            };
        }

        public static User UserApiToData(UserApi userApi)
        {
            return new User() {
                FirtsName = userApi.FirstName,
                Id = userApi.Id,
                LastName = userApi.LastName,
                Login = userApi.Login
            };
        }

        public static Comment CommentApiToData(CommentApi commentApi)
        {
            return new Comment()
            {
                Text = commentApi.Text,
                DateCreated = commentApi.DateCreated,
                Id = commentApi.Id,
                UserId = commentApi.User.Id
            };
        }
    }
}