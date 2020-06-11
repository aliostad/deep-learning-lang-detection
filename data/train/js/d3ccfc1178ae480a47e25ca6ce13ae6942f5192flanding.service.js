angular.module('bazaarr').service('LandingService', function(HashtagsService, UserService, HttpService) {
    this.load = function() {
        if (UserService.is_login) {
            return {};
        }
        HttpService.view_url    = "get_landing_blocks/front";
        HttpService.is_auth     = false;
        var promise = HttpService.get();

        promise.then(function(data){
            if (angular.isDefined(data.data[2].hashtags)) {
                HashtagsService.setHashtags(data.data[2].hashtags);
            }
        });

        return promise;
    };
});
