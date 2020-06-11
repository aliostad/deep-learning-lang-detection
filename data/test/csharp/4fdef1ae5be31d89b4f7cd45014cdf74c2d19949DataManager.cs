using Domain2.Interfaces;

namespace Domain2
{
    public class DataManager
    {
        //туту будут описаны связи
        private IVhodnyeDvRepository vhodnDvRepository;
        private ISliderRepository sliderRepository;
        private IContactRepository contactRepository;
        private IKlientRepository klientRepository;
        private IOplataDostavkaRepository opldostRepository;
        private IUserRepository userRepository;
        private ISeoMainRepository seoMainRepository;
        private ICommentRepository commentRepository;
        private IYstanovkaRepository ystanovkaRepository;
        private IArticlesRepository articlesRepository;
        private IMegkomnatnyeDvRepository megkomDvRepository;
        private IColorsRepository colorsRepository;
        private IAboutUsRepository aboutusRepository;
        private IOurWorksRepository ourworksRepository;

        public DataManager(IOurWorksRepository ourworksRepository,IAboutUsRepository aboutusRepository, IColorsRepository colorsRepository, IMegkomnatnyeDvRepository megkomDvRepository, IArticlesRepository articlesRepository, IYstanovkaRepository ystanovkaRepository, ICommentRepository commentRepository, ISeoMainRepository seoMainRepository, IUserRepository userRepository, IOplataDostavkaRepository opldostRepository, IKlientRepository klientRepository, IVhodnyeDvRepository vhodnDvRepository, ISliderRepository sliderRepository, IContactRepository contactRepository)
        {
            this.ourworksRepository = ourworksRepository;
            this.aboutusRepository = aboutusRepository;
            this.colorsRepository = colorsRepository;
            this.megkomDvRepository = megkomDvRepository;
            this.articlesRepository = articlesRepository;
            this.klientRepository = klientRepository;
            this.vhodnDvRepository = vhodnDvRepository;
            this.sliderRepository = sliderRepository;
            this.contactRepository = contactRepository;
            this.opldostRepository = opldostRepository;
            this.userRepository = userRepository;
            this.seoMainRepository = seoMainRepository;
            this.commentRepository = commentRepository;
            this.ystanovkaRepository = ystanovkaRepository;
        }
        //св-ва через которые будет происх вызов
        public IOurWorksRepository OurWorksRepository
        {
            get { return ourworksRepository; }
        }
        public IAboutUsRepository AboutUsRepository
        {
            get { return aboutusRepository; }
        }
        public IColorsRepository ColorsRepository
        {
            get { return colorsRepository; }
        }
        public IMegkomnatnyeDvRepository MegkomDvRepository
        {
            get { return megkomDvRepository; }
        }
        public IArticlesRepository ArticlesRepository
        {
            get { return articlesRepository; }
        }
        public IYstanovkaRepository YstanovkaRepository
        {
            get { return ystanovkaRepository; }
        }
        public ICommentRepository CommentRepository
        {
            get { return commentRepository; }
        }
        public ISeoMainRepository SeoMainRepository
        {
            get { return seoMainRepository; }
        }
        public IUserRepository UserRepository
        {
            get { return userRepository; }
        }
        public IOplataDostavkaRepository OplDostRepository
        {
            get { return opldostRepository; }
        }
        public IKlientRepository KlientRepository
        {
            get { return klientRepository; }
        }
        public IVhodnyeDvRepository VhodnyeDvRepository
        {
            get { return vhodnDvRepository; }
        }
        public ISliderRepository SliderRepository
        {
            get { return sliderRepository; }
        }
        public IContactRepository ContactRepository
        {
            get { return contactRepository; }
        }

    }
}
