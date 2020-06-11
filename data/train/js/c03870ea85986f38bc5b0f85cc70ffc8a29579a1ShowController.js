var client = require("./client/js/lib/client");

function ShowController ($scope, $state, $stateParams) {
  this.$scope = $scope;
  this.$state = $state;
  this.$stateParams = $stateParams;

  this.findShow()();
}

ShowController.prototype = {
  findShow: function* () {
    var showId = this.$stateParams.showId;
    this.show = yield client.call("findShow", showId);
    console.log(this.show);
    this.redirectToLastSeason();
  },
  redirectToLastSeason: function () {
    if (this.$state.$current.name === "show") {
      var showId = this.show.id;
      var seasonId = this.show.seasons[0].id;
      this.$state.go("show.season", {showId: showId, seasonId: seasonId}, {location: "replace"});
    }
  }
};

App.ctrl(ShowController);


