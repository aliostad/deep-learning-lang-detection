using System;
using BBN.DAL.Interfaces;
using BBN.Models;

namespace BBN.DAL.Repositories
{
    public class UnitOfWork : IUnitOfWork
    {
        BBNEntities db = new BBNEntities();
        private UsersRepository _usersRepository;
        private RolesRepository _rolesRepository;
        private PermissionsRepository _permissionsRepository;
        private TokensRepository _tokensRepository;
        private CitiesRepository _citiesRepository;
        private ActionsRepository _actionsRepository;
        private ControllersRepository _controllersRepository;
        private CountriesRepository _countriesRepository;
        private ExerciesesRepository _exerciesesRepository;
        private ExerciesesGroupRepository _exerciesesGroupRepository;
        private FriendsRepository _friendsRepository;
        private TagsRepository _tagsRepository;
        private PostsRepository _postsRepository;
        private SocialLoginsRepository _socialLoginsRepository;
        private TrainingProgramRepository _trainingProgramRepository;
        private UserDevicesRepository _userDevicesRepository;
        private UserProgramsRepository _userProgramsRepository;
        private ProgramDaysRepository _programDaysRepository;
        private DaysRepository _daysRepository;
        private AlarmsRepository _alarmsRepository;
        private AlarmDaysRepository _alarmDaysRepository;
        private ProductsRepository _productsRepository;
        private ProductTypeRepository _productTypesRepository;
        private MenuRepository _menuRepository;
        private TipsDataRepository _tipsDataRepository;
        private TipsRepository _tipsRepository;
        private UserSettingsRepository _userSettingsRepository;
        private SettingsRepository _settingsRepository;
        private SetDetailsRepository _setDetailsRepository;
        private UserTipsRepository _userTipsRepository;
        private UserResultsRepository _userResultsRepository;

        private bool _disposed;
        public virtual void Dispose(bool disposing)
        {
            if (!_disposed)
            {
                if (disposing)
                {
                    db.Dispose();
                }
                _disposed = true;
            }
        }

        public void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }

        public ICitiesRepository CitiesRepository => _citiesRepository ?? (_citiesRepository = new CitiesRepository(db));

        public IActionsRepository ActionsRepository => _actionsRepository ?? (_actionsRepository = new ActionsRepository(db));

        public IRepository<Controllers> ControllersRepository => _controllersRepository ?? (_controllersRepository = new ControllersRepository(db));

        public IRepository<Countries> CountriesRepository => _countriesRepository ?? (_countriesRepository = new CountriesRepository(db));

        public IRepository<Excercise> ExerciesesRepository => _exerciesesRepository ?? (_exerciesesRepository = new ExerciesesRepository(db));

        public IRepository<ExercieseGroup> ExerciesesGroupRepository => _exerciesesGroupRepository ?? (_exerciesesGroupRepository = new ExerciesesGroupRepository(db));

        public IRepository<Friends> FriendsRepository => _friendsRepository ?? (_friendsRepository = new FriendsRepository(db));

        public ITagsRepository TagsRepository => _tagsRepository ?? (_tagsRepository = new TagsRepository(db));

        public IRepository<Posts> PostsRepository => _postsRepository ?? (_postsRepository = new PostsRepository(db));

        public ISocialLoginRepository SocialLoginsRepository => _socialLoginsRepository ?? (_socialLoginsRepository = new SocialLoginsRepository(db));

        public ITrainingProgramRepository TrainingProgramRepository => _trainingProgramRepository ?? (_trainingProgramRepository  = new TrainingProgramRepository(db));

        public IUserDevicesRepository UserDevicesRepository => _userDevicesRepository ?? (_userDevicesRepository = new UserDevicesRepository(db));

        public IProgramsRepository UserProgramsRepository => _userProgramsRepository ?? (_userProgramsRepository = new UserProgramsRepository(db));

        public IRoleRepository RolesRepository => _rolesRepository ?? (_rolesRepository = new RolesRepository(db));

        public IUserRepository UsersRepository => _usersRepository ?? (_usersRepository = new UsersRepository(db));

        public IPermissionRepository PermissionsRepository => _permissionsRepository ?? (_permissionsRepository = new PermissionsRepository(db));

        public ITokensRepository TokensRepository => _tokensRepository ?? (_tokensRepository = new TokensRepository(db));

        public IProgramDays ProgramDaysRepository => _programDaysRepository ?? (_programDaysRepository = new ProgramDaysRepository(db));

        public IRepository<Days> DaysRepository => _daysRepository ?? (_daysRepository = new DaysRepository(db));

        public IAlarmsRepository AlarmsRepository => _alarmsRepository ?? (_alarmsRepository = new AlarmsRepository(db));

        public IAlarmDaysRepository AlarmDaysRepository => _alarmDaysRepository ?? (_alarmDaysRepository = new AlarmDaysRepository(db));

        public IRepository<Products> ProductsRepository => _productsRepository ?? (_productsRepository = new ProductsRepository(db));

        public IRepository<ProductTypes> ProductTypesRepository => _productTypesRepository ?? (_productTypesRepository = new ProductTypeRepository(db));

        public IMenuRepository MenuRepository => _menuRepository ?? (_menuRepository = new MenuRepository(db));

        public ITipsDataRepository TipsDataRepository => _tipsDataRepository ?? (_tipsDataRepository = new TipsDataRepository(db));

        public IRepository<Tips> TipsRepository => _tipsRepository ?? (_tipsRepository = new TipsRepository(db));

        public IUserSettingsRepository UserSettingsRepository => _userSettingsRepository ?? (_userSettingsRepository = new UserSettingsRepository(db));

        public IRepository<Settings> SettingsRepository => _settingsRepository ?? (_settingsRepository = new SettingsRepository(db));
        public IRepository<SetDetails> SetDetailsRepository => _setDetailsRepository ?? (_setDetailsRepository = new SetDetailsRepository(db));
        public IUserTipsRepository UserTipsRepository => _userTipsRepository ?? (_userTipsRepository = new UserTipsRepository(db));
        public IUserResultsRepository UserResultsRepository => _userResultsRepository ?? (_userResultsRepository = new UserResultsRepository(db));
    }
}
