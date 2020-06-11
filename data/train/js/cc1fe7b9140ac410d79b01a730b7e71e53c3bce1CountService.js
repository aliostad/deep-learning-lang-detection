(function(angular){


    //region CountService
    var CountService = function CountService(TimeService)
    {
        this.count = 0;
        this.TimeService = TimeService;
        this.time = '';
    };


    CountService.prototype.add = function add(a)
    {
        this.count += a;
        this.time = this.TimeService.get();
    };

    CountService.prototype.get = function get()
    {
        return this.count;
    };

    CountService.prototype.getLastTime = function getLastTime()
    {
        return this.time;
    };

    var module = angular.module("count.service", ["time.service"]);
    module.service('CountService', ["TimeService", CountService]);
    //endregion CountService

}).call(this, angular);
