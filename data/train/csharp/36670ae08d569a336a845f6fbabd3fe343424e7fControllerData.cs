using PSAEC.Web.Core.Authentication;
using PSAEC.Web.Model.DAL.Repositories;

namespace PSAEC.Web.Front.Controllers.Data
{
    public class ControllerData: IControllerData
    {
        public IFormsAuthentication FormsAuthentication { get; set; }

        public IAccountRepository AccountRepository { get; set; }
        public IArticlesRepository ArticlesRepository { get; set; }
        public IStaticPagesRepository StaticPagesRepository { get; set; }
        public IFilesRepository FilesRepository { get; set; }
        public ILecturersRepository LecturersRepository { get; set; }
        public IEventsRepository EventsRepository { get; set; }
        public ISettingsRepository SettingsRepository { get; set; }
        public ICommitteeRepository CommitteeRepository { get; set; }
        public ISlideshowRepository SlideshowRepository { get; set; }
        public IAlbumRepository AlbumRepository { get; set; }
        public IGalleryRepository GalleryRepository { get; set; }
        public IFeedbackRepository FeedbackRepository { get; set; }
        public ISessionsRepository SessionsRepository { get; set; }
        public IBannersRepository BannersRepository { get; set; }

        public ControllerData(IFormsAuthentication formsAuthentication, IAccountRepository accountRepository, IArticlesRepository articlesRepository,
            IStaticPagesRepository staticPagesRepository, IFilesRepository filesRepository, ILecturersRepository lecturersRepository,
            IEventsRepository eventsRepository, ISettingsRepository settingsRepository, ICommitteeRepository committeeRepository,
            ISlideshowRepository slideshowRepository, IAlbumRepository albumRepository, IGalleryRepository galleryRepository,
            IFeedbackRepository feedbackRepository, ISessionsRepository sessionsRepository, IBannersRepository bannersRepository)
        {
            this.FormsAuthentication = formsAuthentication;
            this.AccountRepository = accountRepository;
            this.ArticlesRepository = articlesRepository;
            this.StaticPagesRepository = staticPagesRepository;
            this.FilesRepository = filesRepository;
            this.LecturersRepository = lecturersRepository;
            this.EventsRepository = eventsRepository;
            this.SettingsRepository = settingsRepository;
            this.CommitteeRepository = committeeRepository;
            this.SlideshowRepository = slideshowRepository;
            this.AlbumRepository = albumRepository;
            this.GalleryRepository = galleryRepository;
            this.FeedbackRepository = feedbackRepository;
            this.SessionsRepository = sessionsRepository;
            this.BannersRepository = bannersRepository;
        }
    }
}