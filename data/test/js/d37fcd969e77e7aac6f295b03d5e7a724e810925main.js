
var settings = new AppSettings();

// GLOBALS
// var appController = new AppController(appSettings);
// appController.init();

var authController = new AuthController(settings.auth); 
var pageController = new PageController(authController.isLoggedIn);
var dataController = new DataController(settings, pageController); 


function onBodyLoad() {
  console.log('Requesting login status.');
  authController.displayLoginStatus();

  if (authController.isLoggedIn) {
    console.log('Logged in. Starting data controller.');
    dataController.start();
    // appView.displayMainRow();

    // Load list of projects
    // var appDataController = new AppDataController(); 
    // appDataController.init(gDataController);

  } else {
    // appView.displayNotLoggedInAlert();

  }
}
