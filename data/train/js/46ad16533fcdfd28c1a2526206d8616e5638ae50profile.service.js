(function () {
    'use strict';
    angular.module('public')
        .service('ProfileService', ProfileService);

    ProfileService.$inject = ['MenuService'];
    function ProfileService(MenuService) {
        var profileService = this;
        profileService.profile = {};
        profileService.profile_saved = false;
        profileService.getProfile = function () {
            return profileService.profile;
        };

        profileService.saveProfile = function (first_name, last_name, email, phone, favorite_dish) {
            MenuService.getItem(favorite_dish).then(function (response) {
                profileService.profile.first_name = first_name;
                profileService.profile.last_name = last_name;
                profileService.profile.email = email;
                profileService.profile.phone = phone;
                profileService.profile.favorite_dish = response;
                console.log(response);

                profileService.profile_saved = true;

            });
        };

        profileService.isSaved = function () {
            return profileService.profile_saved;
        };


    };
})();