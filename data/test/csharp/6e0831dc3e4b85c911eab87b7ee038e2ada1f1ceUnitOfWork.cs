


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



        private ILessonRepository _lessonRepository;
        public ILessonRepository LessonRepository
        {
            get { return _lessonRepository ?? (_lessonRepository = new LessonRepository(DataContext)); }
        }

        private ILessonPlanRepository _lessonPlanRepository;
        public ILessonPlanRepository LessonPlanRepository
        {
            get { return _lessonPlanRepository ?? (_lessonPlanRepository = new LessonPlanRepository(DataContext)); }
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


        private IGalleryImageRepository _galleryImageRepository;
        public IGalleryImageRepository GalleryImageRepository
        {
            get { return _galleryImageRepository ?? (_galleryImageRepository = new GalleryImageRepository(DataContext)); }
        }


        private IArticleRepository _articleRepository;
        public IArticleRepository ArticleRepository
        {
            get { return _articleRepository ?? (_articleRepository = new ArticleRepository(DataContext)); }
        }


        private IActivityRepository _activityRepository;
        public IActivityRepository ActivityRepository
        {
            get { return _activityRepository ?? (_activityRepository = new ActivityRepository(DataContext)); }
        }
        

        private IVideoRepository _videoRepository;

        public IVideoRepository VideoRepository
        {
            get { return _videoRepository ?? (_videoRepository = new VideoRepository(DataContext));}
        }


        private IWebUserRepository _webUserRepository;
        public IWebUserRepository WebUserRepository
        {
            get { return _webUserRepository ?? (_webUserRepository = new WebUserRepository(DataContext)); }
        }
    }
}
