namespace FootballBetting.Data.UnitsOfWork
{
    using System;

    using Contexts;
    using Repositories;
    using Models;

    public class GenericUnitOfWork : IDisposable
    {
        private readonly FootballBettingContext context = new FootballBettingContext();

        private GenericRepository<Bet> betsRepository;
        private GenericRepository<BetGame> betsGamesRepository;
        private GenericRepository<Color> colorsRepository;
        private GenericRepository<Competition> competitionsRepository;
        private GenericRepository<CompetitionType> competitionTypesRepository;
        private GenericRepository<Continent> continentsRepository;
        private GenericRepository<Country> countriesRepository;
        private GenericRepository<Game> gamesRepository;
        private GenericRepository<Player> playersRepository;
        private GenericRepository<Position> positionsRepository;
        private GenericRepository<ResultPrediction> resultPredictionsRepository;
        private GenericRepository<Round> roundsRepository;
        private GenericRepository<Team> teamsRepository;
        private GenericRepository<Town> townsRepository;
        private GenericRepository<User> usersRepository;

        private bool isDisposed = false;

        public GenericRepository<Bet> BetsRepository
        {
            get
            {
                if (this.betsRepository == default(GenericRepository<Bet>))
                {
                    this.betsRepository = new GenericRepository<Bet>(this.context);
                }

                return this.betsRepository;
            }
        }

        public GenericRepository<BetGame> BetsGamesRepository
        {
            get
            {
                if (this.betsGamesRepository == default(GenericRepository<BetGame>))
                {
                    this.betsGamesRepository = new GenericRepository<BetGame>(this.context);
                }

                return this.betsGamesRepository;
            }
        }

        public GenericRepository<Color> ColorsRepository
        {
            get
            {
                if (this.colorsRepository == default(GenericRepository<Color>))
                {
                    this.colorsRepository = new GenericRepository<Color>(this.context);
                }

                return this.colorsRepository;
            }
        }

        public GenericRepository<Competition> CompetitionsRepository
        {
            get
            {
                if (this.competitionsRepository == default(GenericRepository<Competition>))
                {
                    this.competitionsRepository = new GenericRepository<Competition>(this.context);
                }

                return this.competitionsRepository;
            }
        }

        public GenericRepository<CompetitionType> CompetitionTypesRepository
        {
            get
            {
                if (this.competitionTypesRepository == default(GenericRepository<CompetitionType>))
                {
                    this.competitionTypesRepository = new GenericRepository<CompetitionType>(this.context);
                }

                return this.competitionTypesRepository;
            }
        }

        public GenericRepository<Continent> ContinentsRepository
        {
            get
            {
                if (this.continentsRepository == default(GenericRepository<Continent>))
                {
                    this.continentsRepository = new GenericRepository<Continent>(this.context);
                }

                return this.continentsRepository;
            }
        }

        public GenericRepository<Country> CountriesRepository
        {
            get
            {
                if (this.countriesRepository == default(GenericRepository<Country>))
                {
                    this.countriesRepository = new GenericRepository<Country>(this.context);
                }

                return this.countriesRepository;
            }
        }

        public GenericRepository<Game> GamesRepository
        {
            get
            {
                if (this.gamesRepository == default(GenericRepository<Game>))
                {
                    this.gamesRepository = new GenericRepository<Game>(this.context);
                }

                return this.gamesRepository;
            }
        }

        public GenericRepository<Player> PlayersRepository
        {
            get
            {
                if (this.playersRepository == default(GenericRepository<Player>))
                {
                    this.playersRepository = new GenericRepository<Player>(this.context);
                }

                return this.playersRepository;
            }
        }

        public GenericRepository<Position> PositionsRepository
        {
            get
            {
                if (this.positionsRepository == default(GenericRepository<Position>))
                {
                    this.positionsRepository = new GenericRepository<Position>(this.context);
                }

                return this.positionsRepository;
            }
        }

        public GenericRepository<ResultPrediction> ResultPredictionsRepository
        {
            get
            {
                if (this.resultPredictionsRepository == default(GenericRepository<ResultPrediction>))
                {
                    this.resultPredictionsRepository = new GenericRepository<ResultPrediction>(this.context);
                }

                return this.resultPredictionsRepository;
            }
        }

        public GenericRepository<Round> RoundsRepository
        {
            get
            {
                if (this.roundsRepository == default(GenericRepository<Round>))
                {
                    this.roundsRepository = new GenericRepository<Round>(this.context);
                }

                return this.roundsRepository;
            }
        }

        public GenericRepository<Team> TeamsRepository
        {
            get
            {
                if (this.teamsRepository == default(GenericRepository<Team>))
                {
                    this.teamsRepository = new GenericRepository<Team>(this.context);
                }

                return this.teamsRepository;
            }
        }

        public GenericRepository<Town> TownsRepository
        {
            get
            {
                if (this.townsRepository == default(GenericRepository<Town>))
                {
                    this.townsRepository = new GenericRepository<Town>(this.context);
                }

                return this.townsRepository;
            }
        }

        public GenericRepository<User> UsersRepository
        {
            get
            {
                if (this.usersRepository == default(GenericRepository<User>))
                {
                    this.usersRepository = new GenericRepository<User>(this.context);
                }

                return this.usersRepository;
            }
        }

        public void Dispose(bool isDisposing)
        {
            if (!this.isDisposed)
            {
                if (isDisposing)
                {
                    this.context.Dispose();
                }
            }

            this.isDisposed = true;
        }

        public void Dispose()
        {
            this.Dispose(true);
            GC.SuppressFinalize(this);
        }
    }
}
