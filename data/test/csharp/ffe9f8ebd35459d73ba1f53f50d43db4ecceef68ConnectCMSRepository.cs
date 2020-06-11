namespace ConnectCMS.Repositories
{
	public class ConnectCMSRepository : BaseRepository
	{
		private AccountRepository _accountRepository;
		private BingRepository _bingRepository;
		private CategoryRepository _categoryRepository;
		private DeviceRepository _deviceRepository;
		private EnterpriseRepository _enterpriseRepository;
		private EventRepository _eventRepository;
		private HotelRepository _hotelRepository;
		private HotelBrandRepository _hotelBrandRepository;
		private ImageRepository _imageRepository;
		private RecommendationRepository _recommendationRepository;
		private SalesForceRepository _salesForceRepository;
		private SecurityRepository _securityRepository;
		private TipRepository _tipRepository;
		private UtilityRepository _utilityRepository;
		private IReleaseNoteRepository _releaseNoteRepository;
		private IRequestRepository _requestRepository;
		private EntityRepository _entityRepository;
		private EnvisionRepository _envisionRepository;
		private EmailRepository _emailRepository;
		private IDashboardRepository _dashboardRepository;
		private AnalyticRepository _analyticRepository;
		private MobileAppRepository _mobileAppRepository;
		private SubDeviceRepository _subDeviceRepository;
		private SmsRepository _smsRepository;
		private BeaconRepository _beaconRepository;
		private WelcomeTabletRepository _welcomeTabletRepository;
		private MarketingCampaignRepository _marketingCampaignRepository;
		private INotificationRepository _notificationRepository;

		public AccountRepository AccountRepository
		{
			get { return _accountRepository ?? ( _accountRepository = new AccountRepository( this ) ); }
		}

		public BingRepository BingRepository
		{
			get { return _bingRepository ?? ( _bingRepository = new BingRepository( this ) ); }
		}

		public CategoryRepository CategoryRepository
		{
			get { return _categoryRepository ?? ( _categoryRepository = new CategoryRepository( this ) ); }
		}

		public DeviceRepository DeviceRepository
		{
			get { return _deviceRepository ?? ( _deviceRepository = new DeviceRepository( this ) ); }
		}

		public EnterpriseRepository EnterpriseRepository
		{
			get { return _enterpriseRepository ?? ( _enterpriseRepository = new EnterpriseRepository( this ) ); }
		}

		public EventRepository EventRepository
		{
			get { return _eventRepository ?? ( _eventRepository = new EventRepository( this ) ); }
		}

		public HotelRepository HotelRepository
		{
			get { return _hotelRepository ?? ( _hotelRepository = new HotelRepository( this ) ); }
		}

		public HotelBrandRepository HotelBrandRepository
		{
			get { return _hotelBrandRepository ?? ( _hotelBrandRepository = new HotelBrandRepository( this ) ); }
		}

		public ImageRepository ImageRepository
		{
			get { return _imageRepository ?? ( _imageRepository = new ImageRepository( this ) ); }
		}

		public RecommendationRepository RecommendationRepository
		{
			get { return _recommendationRepository ?? ( _recommendationRepository = new RecommendationRepository( this ) ); }
		}

		public SalesForceRepository SalesForceRepository
		{
			get { return _salesForceRepository ?? ( _salesForceRepository = new SalesForceRepository( this ) ); }
		}

		public SecurityRepository SecurityRepository
		{
			get { return _securityRepository ?? ( _securityRepository = new SecurityRepository( this ) ); }
		}

		public TipRepository TipRepository
		{
			get { return _tipRepository ?? ( _tipRepository = new TipRepository( this ) ); }
		}

		public UtilityRepository UtilityRepository
		{
			get { return _utilityRepository ?? ( _utilityRepository = new UtilityRepository( this ) ); }
		}

		public IReleaseNoteRepository ReleaseNoteRepository
		{
			get { return _releaseNoteRepository ?? ( _releaseNoteRepository = new ReleaseNotesRepository( this ) ); }
		}

		public IRequestRepository RequestRepository
		{
			get { return _requestRepository ?? ( _requestRepository = new RequestRepository( this ) ); }
		}

		public EntityRepository EntityRepository
		{
			get { return _entityRepository ?? ( _entityRepository = new EntityRepository( this ) ); }
		}

		public EnvisionRepository EnvisionRepository
		{
			get { return _envisionRepository ?? ( _envisionRepository = new EnvisionRepository( this ) ); }
		}

		public EmailRepository EmailRepository
		{
			get { return _emailRepository ?? ( _emailRepository = new EmailRepository( this ) ); }
		}

		public IDashboardRepository DashboardRepository
		{
			get { return _dashboardRepository ?? ( _dashboardRepository = new DashboardRepository( this ) ); }
		}

		public AnalyticRepository AnalyticRepository
		{
			get { return _analyticRepository ?? ( _analyticRepository = new AnalyticRepository( this ) ); }
		}

		public MobileAppRepository MobileAppRepository
		{
			get { return _mobileAppRepository ?? ( _mobileAppRepository = new MobileAppRepository( this ) ); }
		}

		public SubDeviceRepository SubDeviceRepository
		{
			get { return _subDeviceRepository ?? ( _subDeviceRepository = new SubDeviceRepository( this ) ); }
		}

		public SmsRepository SmsRepository
		{
			get { return _smsRepository ?? ( _smsRepository = new SmsRepository( this ) ); }
		}

		public BeaconRepository BeaconRepository
		{
			get { return _beaconRepository ?? ( _beaconRepository = new BeaconRepository( this ) ); }
		}

		public WelcomeTabletRepository WelcomeTabletRepository
		{
			get { return _welcomeTabletRepository ?? ( _welcomeTabletRepository = new WelcomeTabletRepository( this ) ); }
		}

		public MarketingCampaignRepository MarketingCampaignRepository
		{
			get { return _marketingCampaignRepository ?? ( _marketingCampaignRepository = new MarketingCampaignRepository( this ) ); }
		}
		public INotificationRepository NotificationRepository
		{
			get { return _notificationRepository ?? ( _notificationRepository = new NotificationRepository( this ) ); }
		}
	}
}