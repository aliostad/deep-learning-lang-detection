
//enums
var postType = { post: "post", quote: "quote", upload: "upload" };

var COUNT_POST_PER_CALL = 20;
var COUNT_SEARCH_BOOKS_PER_CALL = 20;
var LENGUAGE="he";
var dictionaryURL;
var DICTIONARY;

//create controllers
var data = new Data();
var stackviewController = new StackviewController();
var modelController = new ModelController();
var serverController = new ServerController();
var loginController = new LoginController();
var headerController = new HeaderController();
var shelfController = new ShelfController();
var feedsController = new FeedsController();
var postController = new PostController();
var bookController = new BookController();
var groupController = new GroupController();
var homeController = new HomeController();
var settingsController = new SettingsController();
var recomandedBooksController = new RecomandedBooksController();
var publiLlibraryController = new PubliLlibraryController();
var movieHendler = new MovieHendler();
var aboutController = new AboutController();
var systemMessageController = new SystemMessageController();
var navigationController = new NavigationController();
var notificationsController = new NotificationsController();






switch(LENGUAGE){
	
	case "en":{
		
		dictionaryURL="../dictionaryEN.txt"	;
		break;
	}
		
	default: {//hebrew dic
	
		dictionaryURL="../dictionaryHE.txt"	;
		break;
	}
}



$.ajax({
    type: "GET",
    url: dictionaryURL,
    dataType: 'json'
})
.done(init)
.fail(function (error) {
    console.log(error);
});

function init(dic) {
    
    DICTIONARY = dic;
    console.log(DICTIONARY);    
	showLoader();	
	stackviewController.attachEvent();	
	loginController.attachEvent();	
	headerController.attachEvent();	
	shelfController.attachEvent();	
	feedsController.attachEvent();	
	postController.attachEvent();	
	bookController.attachEvent();	
	groupController.attachEvent();
	groupController.init();	
	homeController.attachEvent();	
	settingsController.attachEvent();	
	recomandedBooksController.attachEvent();	
	publiLlibraryController.attachEvent();	
	aboutController.attachEvent();	
	navigationController.attachEvent();
	navigationController.changeHash();
	systemMessageController.attachEvent();
    notificationsController.attachEvent();
}