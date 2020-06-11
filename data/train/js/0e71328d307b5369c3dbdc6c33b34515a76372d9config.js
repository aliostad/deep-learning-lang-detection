(function()
{
  angular
    .module("PandaMusicApp")
    .config(Config);
    
  function Config($routeProvider)
  {
    $routeProvider
			.when("/home",
      {
        templateUrl: "home/home.view.html",
        controller: "HomeController",
				controllerAs: "model"
      })
			.when("/search",
      {
        templateUrl: "search/search.view.html",
        controller: "SearchController",
				controllerAs: "model"
      })
		  .when("/admin",
      {
        templateUrl: "admin/admin.view.html",
        controller: "AdminController",
				controllerAs: "model"
      })
      .when("/login",
      {
        templateUrl: "login/login.view.html",
        controller: "LoginController",
				controllerAs: "model"
      })
		  .when("/logout",
      {
        templateUrl: "logout/logout.view.html",
        controller: "LogoutController",
				controllerAs: "model"
      })
      .when("/register",
      {
        templateUrl: "register/register.view.html",
        controller: "RegisterController",
				controllerAs: "model"
      })
		  .when("/header",
      {
        templateUrl: "header/header.view.html",
        controller: "HeaderController",
				controllerAs: "model"
      })
      .when("/profile",
      {
        templateUrl: "profile/profile.view.html",
        controller: "ProfileController",
				controllerAs: "model"
      })
      .when("/album",
      {
        templateUrl: "album/album.view.html",
        controller: "AlbumController",
				controllerAs: "model"
      })
			.when("/artist",
      {
        templateUrl: "artist/artist.view.html",
        controller: "ArtistController",
				controllerAs: "model"
      })
			.when("/song",
      {
        templateUrl: "song/song.view.html",
        controller: "SongController",
				controllerAs: "model"
      })
			.when("/user",
      {
        templateUrl: "user/user.view.html",
        controller: "UserController",
				controllerAs: "model"
      })
			.when("/user-comment",
      {
        templateUrl: "user-comment/user-comment.view.html",
        controller: "UserCommentController",
				controllerAs: "model"
      })
			.when("/user-follow",
      {
        templateUrl: "user-follow/user-follow.view.html",
        controller: "UserFollowController",
				controllerAs: "model"
      })
			.when("/view-user",
      {
        templateUrl: "view-user/view-user.view.html",
        controller: "ViewUserController",
				controllerAs: "model"
      })
      .otherwise({
        redirectTo: "/home"
      })
  }
})();