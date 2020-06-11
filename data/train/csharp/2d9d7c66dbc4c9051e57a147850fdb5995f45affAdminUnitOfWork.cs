using Data;
using EnglishPremierLeagueApp.Models;
using Microsoft.EntityFrameworkCore;

namespace EnglishPremierLeagueApp.UnitOfWorks
{
    public class AdminUnitOfWork : UnitOfWork
    {
        public readonly IMutableRepository<Games> GamesRepository;
        public readonly IMutableRepository<LeagueTable> LeagueTableRepository;
        public readonly IMutableRepository<Seasons> SeasonsRepository;
        public readonly IRepository<Teams> TeamsRepository;
        public AdminUnitOfWork(DbContext context) : base(context)
        {
            GamesRepository = RepositoryFactory.CreateRepository<IMutableRepository<Games>>(context);
            LeagueTableRepository = RepositoryFactory.CreateRepository<IMutableRepository<LeagueTable>>(context);
            SeasonsRepository = RepositoryFactory.CreateRepository<IMutableRepository<Seasons>>(context);
            TeamsRepository = RepositoryFactory.CreateRepository<IRepository<Teams>>(context);
        }
    }
}