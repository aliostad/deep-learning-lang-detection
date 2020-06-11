using DAL.Model;
using DAL.Repository.Implementations;
using DAL.Repository.Interfaces;
using Ninject;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;

namespace DAL.Repository
{
    public class UnitOfWork : IUnitOfWork
    {
        public FloorballBaseCtx Ctx { get; set; }

        private IEventRepository eventRepository;

        [Inject]
        public IEventRepository EventRepository
        {
            get => eventRepository;
            set
            {
                eventRepository = value;
                eventRepository.Ctx = Ctx;
            }
        }

        private ILeagueRepository leagueRepository;

        [Inject]
        public ILeagueRepository LeagueRepository
        {
            get => leagueRepository; 
            set
            {
                leagueRepository = value;
                leagueRepository.Ctx = Ctx;
            }
        }

        private IMatchRepository matchRepository;

        [Inject]
        public IMatchRepository MatchRepository
        {
            get => matchRepository;
            set
            {
                matchRepository = value;
                matchRepository.Ctx = Ctx;
            }
        }

        private IPlayerRepository playerRepository;

        [Inject]
        public IPlayerRepository PlayerRepository
        {
            get => playerRepository; 
            set
            {
                playerRepository = value;
                playerRepository.Ctx = Ctx;
            }
        }

        private IRefereeRepository refereeRepository;

        [Inject]
        public IRefereeRepository RefereeRepository
        {
            get => refereeRepository;
            set
            {
                refereeRepository = value;
                refereeRepository.Ctx = Ctx;
            }
        }

        private ITeamRepository teamRepository;

        [Inject]
        public ITeamRepository TeamRepository
        {
            get => teamRepository;
            set
            {
                teamRepository = value;
                teamRepository.Ctx = Ctx;
            }
        }

        private IEventMessageRepository eventMessageRepository;

        [Inject]
        public IEventMessageRepository EventMessageRepository
        {
            get => eventMessageRepository;
            set
            {
                eventMessageRepository = value;
                eventMessageRepository.Ctx = Ctx;
            }
        }

        private IStatisticRepository statisticRepository;

        [Inject]
        public IStatisticRepository StatisticRepository
        {
            get => statisticRepository; 
            set
            {
                statisticRepository = value;
                statisticRepository.Ctx = Ctx;
            }
        }

        private IStadiumRepository stadiumRepository;

        [Inject]
        public IStadiumRepository StadiumRepository
        {
            get => stadiumRepository; 
            set
            {
                stadiumRepository = value;
                stadiumRepository.Ctx = Ctx;
            }
        }

        private IUserRepository userRepository;

        [Inject]
        public IUserRepository UserRepository
        {
            get => userRepository; 
            set
            {
                userRepository = value;
                userRepository.Ctx = Ctx;
            }
        }

        private IRoleRepository roleRepository;

        [Inject]
        public IRoleRepository RoleRepository
        {
            get => roleRepository;
            set
            {
                roleRepository = value;
                roleRepository.Ctx = Ctx;
            }
        }

        private ISecurityRepository securityRepository;

        [Inject]
        public ISecurityRepository SecurityRepository
        {
            get => securityRepository;
            set
            {
                securityRepository = value;
                securityRepository.Ctx = Ctx;
            }
        }

        private IFloorballRepository repository;

        [Inject]
        public IFloorballRepository Repository
        {
            get => repository;
            set
            {
                repository = value;
                repository.Ctx = Ctx;
            }
        }

        public UnitOfWork(FloorballBaseCtx ctx)
        {
            Ctx = ctx;

            //kernel = new StandardKernel();
            //kernel.Load(Assembly.GetExecutingAssembly());

            //Ctx = kernel.Get<FloorballBaseCtx>();

            //TeamRepository = kernel.Get<ITeamRepository>();
            //TeamRepository.Ctx = Ctx;

            //EventMessageRepository = kernel.Get<IEventMessageRepository>();
            //EventMessageRepository.Ctx = Ctx;

            //EventRepository = kernel.Get<IEventRepository>();
            //EventRepository.Ctx = Ctx;

            //MatchRepository = kernel.Get<IMatchRepository>();
            //MatchRepository.Ctx = Ctx;

            //PlayerRepository = kernel.Get<IPlayerRepository>();
            //PlayerRepository.Ctx = Ctx;

            //StadiumRepository = kernel.Get<IStadiumRepository>();
            //StadiumRepository.Ctx = Ctx;

            //StatisticRepository = kernel.Get<IStatisticRepository>();
            //StatisticRepository.Ctx = Ctx;

            //LeagueRepository = kernel.Get<ILeagueRepository>();
            //LeagueRepository.Ctx = Ctx;

            //RefereeRepository = kernel.Get<IRefereeRepository>();
            //RefereeRepository.Ctx = Ctx;

            //UserRepository = kernel.Get<IUserRepository>();
            //UserRepository.Ctx = Ctx;

            //RoleRepository = kernel.Get<IRoleRepository>();
            //RoleRepository.Ctx = Ctx;

            //Repository = kernel.Get<IRepository>();

        }


        public void Save()
        {
            Ctx.SaveChanges();
            
        }

        private bool disposed = false;

        

        protected virtual void Dispose(bool disposing)
        {
            if (!disposed)
            {
                if (disposing)
                {
                    Ctx.Dispose();
                }
            }
            disposed = true;
        }

        public void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }
    }
}
