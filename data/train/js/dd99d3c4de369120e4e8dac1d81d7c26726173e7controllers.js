(function (ng, routes) {
  "use strict";
  var
    HomeController, LoginController, AboutController, ProfileController,
    FriendsController, RegisterController;
  HomeController     = function HomeControllerF() {

  };
  LoginController    = function LoginControllerF() {};
  AboutController    = function AboutControllerF() {};
  ProfileController  = function ProfileControllerF() {};
  FriendsController  = function FriendsControllerF() {};
  RegisterController = function RegisterControllerF() {};
  ng.module("app")
    .controller("HomeController", HomeController)
    .controller("LoginController", LoginController)
    .controller("AboutController", AboutController)
    .controller("ProfileController", ProfileController)
    .controller("FriendsController", FriendsController)
    .controller("RegisterController", RegisterController);
}(angular, routes));
