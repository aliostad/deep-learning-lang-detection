using Leikjavefur.Models.Interfaces;

namespace Leikjavefur.Models.Repository
{
    public class DataRepository : IDataRepository
    {
        public IUserRepository UserRepository { get; set; }
        public IGameInstanceRepository GameInstanceRepository { get; set; }
        public IGameRepository GameRepository { get; set; }
        public IStatisticRepository StatisticRepository { get; set; }

        public DataRepository()
        {
            UserRepository = new UserRepository();
            GameRepository = new GameRepository();
            GameInstanceRepository = new GameInstanceRepository();
            StatisticRepository = new StatisticRepository();
        }

    }
}