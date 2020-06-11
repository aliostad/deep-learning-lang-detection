using MathSite.Db;

namespace MathSite.Repository.Core
{
    public class RepositoryManager : IRepositoryManager
    {
        public RepositoryManager(
            IGroupsRepository groupsRepository,
            IPersonsRepository personsRepository,
            IUsersRepository usersRepository,
            IFilesRepository filesRepository,
            ISiteSettingsRepository siteSettingsRepository,
            IRightsRepository rightsRepository,
            IPostsRepository postsRepository,
            IPostSeoSettingsRepository postSeoSettingsRepository,
            IPostSettingRepository postSettingRepository,
            IPostTypeRepository postTypeRepository, 
            IGroupTypeRepository groupTypeRepository
        )
        {
            GroupsRepository = groupsRepository;
            PersonsRepository = personsRepository;
            UsersRepository = usersRepository;
            FilesRepository = filesRepository;
            SiteSettingsRepository = siteSettingsRepository;
            RightsRepository = rightsRepository;
            PostsRepository = postsRepository;
            PostSeoSettingsRepository = postSeoSettingsRepository;
            PostSettingRepository = postSettingRepository;
            PostTypeRepository = postTypeRepository;
            GroupTypeRepository = groupTypeRepository;
        }

        public IGroupsRepository GroupsRepository { get; }
        public IPersonsRepository PersonsRepository { get; }
        public IUsersRepository UsersRepository { get; }
        public IFilesRepository FilesRepository { get; }
        public ISiteSettingsRepository SiteSettingsRepository { get; }
        public IRightsRepository RightsRepository { get; }
        public IPostsRepository PostsRepository { get; }
        public IPostSeoSettingsRepository PostSeoSettingsRepository { get; }
        public IPostSettingRepository PostSettingRepository { get; }
        public IPostTypeRepository PostTypeRepository { get; }
        public IGroupTypeRepository GroupTypeRepository { get; }
    }
}