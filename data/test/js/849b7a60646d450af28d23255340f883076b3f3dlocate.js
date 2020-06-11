var GoblinGold;
(function (GoblinGold) {
    var LocateService = (function () {
        function LocateService() {
        }
        LocateService.prototype.currentLocation = function () {
            navigator.geolocation.getCurrentPosition(function (position) {
                console.log(position);
            });
        };
        LocateService.$inject = [];
        return LocateService;
    })();
    GoblinGold.LocateService = LocateService;
    angular
        .module("GoblinGold")
        .service("LocateService", LocateService);
})(GoblinGold || (GoblinGold = {}));
