using System;

namespace GameRoom.GameService.Data
{
    public interface IGameServiceDataRepositoryFactory
    {
        GameServiceDataRepository Build();
    }

    public class GameServiceDataRepository
    {
        private readonly IPlayerRepository _PlayerRepository;
        private readonly IGameResultRepository _GameResultRepository;
        private readonly IPlayerStatusRepository _PlayerStatusRepository;
        private readonly IGameTypeRepository _GameTypeRepository;
        private readonly IPlayerStateRepository _PlayerStateRepository;

        public GameServiceDataRepository(
            IPlayerRepository playerRepository,
            IGameResultRepository gameResultRepository,
            IPlayerStatusRepository playerStatusRepository,
            IGameTypeRepository gameTypeRepository,
            IPlayerStateRepository playerStateRepository)
        {
            if (ReferenceEquals(playerRepository, null)) throw new ArgumentNullException("playerRepository");
            if (ReferenceEquals(gameResultRepository, null)) throw new ArgumentNullException("gameResultRepository");
            if (ReferenceEquals(playerStatusRepository, null)) throw new ArgumentNullException("playerStatusRepository");
            if (ReferenceEquals(gameTypeRepository, null)) throw new ArgumentNullException("gameTypeRepository");
            if (ReferenceEquals(playerStateRepository, null)) throw new ArgumentNullException("playerStateRepository");

            _PlayerRepository = playerRepository;
            _GameResultRepository = gameResultRepository;
            _PlayerStatusRepository = playerStatusRepository;
            _GameTypeRepository = gameTypeRepository;
            _PlayerStateRepository = playerStateRepository;
        }

        public IPlayerRepository PlayerRepository
        {
            get { return _PlayerRepository; }
        }

        public IGameResultRepository GameResultRepository
        {
            get { return _GameResultRepository; }
        }

        public IPlayerStatusRepository PlayerStatusRepository
        {
            get { return _PlayerStatusRepository; }
        }

        public IGameTypeRepository GameTypeRepository
        {
            get { return _GameTypeRepository; }
        }

        public IPlayerStateRepository PlayerStateRepository
        {
            get { return _PlayerStateRepository; }
        }
    }
}