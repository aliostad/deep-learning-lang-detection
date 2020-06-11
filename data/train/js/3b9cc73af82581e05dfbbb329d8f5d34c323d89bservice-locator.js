
function ServiceLocator() {

	// Create services
	this.localStorage = new LocalStorage();
	this.prefsService = new PrefsService();
	this.httpClient = httpClientCtor({ prefsService: this.prefsService });
	this.authService = authServiceCtor({ httpClient: this.httpClient, localStorage: this.localStorage });
	this.siteService = siteServiceCtor({ httpClient: this.httpClient, prefsService: this.prefsService });   //new SiteService();
	this.videoService = new VideoService();
	this.netService = new NetService();

	// Resolve dependencies
	this.videoService.httpClient = this.httpClient;
	this.videoService.prefsService = this.prefsService;
	this.videoService.netService = this.netService;
	this.prefsService.localStorage = this.localStorage;
	this.netService.httpClient = this.httpClient;
	
	// Other setup
	this.prefsService.load();
}

