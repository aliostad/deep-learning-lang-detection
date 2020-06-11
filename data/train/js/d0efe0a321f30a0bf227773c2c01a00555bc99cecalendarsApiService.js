"use strict";

profile.service("calendarsApiService", ["apiService", function (api) {

    var self = this;

    self.getCalendars = function() {
        return api.get("/api/settings/calendar");
    };

    self.getCalendar = function(id) {
        return api.get("/api/settings/calendar/" + id);
    };

    self.createCalendar = function(calendar) {
        return api.post("/api/settings/calendar", calendar);
    };

    self.updateCalendar = function(calendar) {
        return api.put("/api/settings/calendar", calendar);
    };

    self.deleteCalendar = function(id) {
        return api.delete("/api/settings/calendar/" + id);
    };

    return self;

}]);