Template.showsInfo.helpers({
    show: function() {
        if(Meteor.user()) {
            var showToShow = Session.get("show-to-show");


            if(showToShow) {
                console.log(showToShow);

                return showToShow;
            }
        }
    },

    getShowInfo: function() {
        var showToShow = Session.get("show-to-show");
        var showInfo = Session.get("show-id-" + showToShow);

        if(!showInfo) {
            var imdbID = Session.get("showImdb-to-show");


            Meteor.call('getShow', showToShow, imdbID, function (err, result) {

                Session.setPersistent("show-id-" + showToShow, result);

                return result;
            });
        }
    }
});