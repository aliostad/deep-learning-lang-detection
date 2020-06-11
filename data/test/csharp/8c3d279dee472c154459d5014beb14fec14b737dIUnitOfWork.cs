using DB.Entities;
using System;
using System.Collections.Generic;
using System.Text;

namespace Interfaces.DAL
{
    public interface IUnitOfWork : IDisposable
    {
        IGenericRepository<City> CityRepository { get; }
        IGenericRepository<Country> CountryRepository { get; }
        IGenericRepository<Match> MatchRepository { get; }
        IGenericRepository<Rating> RatingRepository { get; }
        IGenericRepository<RatingList> RatingListRepository { get; }
        IGenericRepository<Stage> StageRepository { get; }
        IGenericRepository<Team> TeamRepository { get; }
        IGenericRepository<Tournament> TournamentRepository { get; }
        IGenericRepository<Tour> TourRepository { get; }

        void Save();
    }
}
