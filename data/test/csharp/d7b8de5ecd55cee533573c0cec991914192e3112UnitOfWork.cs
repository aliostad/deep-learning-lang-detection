using Zamin.Repositories.Category;


//using Zamin.Repositories.Users;

namespace Zamin.Repositories
{
    public class UnitOfWork : UnitOfWorkBase<DataContext>
    {
        private IUsersRepository _usersRepository;
        public IUsersRepository UsersRepository
        {
            get { return _usersRepository ?? (_usersRepository = new UsersRepository(DataContext)); }
        }

        private ICourseRepository _courseRepository;
        public ICourseRepository CourseRepository
        {
            get { return _courseRepository ?? (_courseRepository = new CourseRepository(DataContext)); }
        }

        private ICategoryRepository _categoryRepository;
        public ICategoryRepository CategoryRepository
        {
            get { return _categoryRepository ?? (_categoryRepository = new CategoryRepository(DataContext)); }
        }

        private ITagRepository _tagRepository;
        public ITagRepository TagRepository
        {
            get { return _tagRepository ?? (_tagRepository = new TagRepository(DataContext)); }
        }

        private IPosterRepository _posterRepository;
        public IPosterRepository PosterRepository
        {
            get { return _posterRepository ?? (_posterRepository = new PosterRepository(DataContext)); }
        }

        private IWebUserRepository _webUserRepository;
        public IWebUserRepository WebUserRepository
        {
            get { return _webUserRepository ?? (_webUserRepository = new WebUserRepository(DataContext)); }
        }
    }
}
