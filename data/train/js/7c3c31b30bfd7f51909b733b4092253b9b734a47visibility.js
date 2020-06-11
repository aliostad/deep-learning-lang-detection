app.factory("visibility", function() {
    var service = {};
    service.visible = new Set();

    service.isVisible = function(id) {
        return service.visible.has(id);
    };

    service.toggle = function(id) {
        if (service.isVisible(id)) {
            service.hide(id);
        } else {
            service.show(id);
        }
    };

    service.show = function(id) {
        service.visible.add(id);
    };

    service.hide = function(id) {
        service.visible.delete(id);
    };

    service.showDays = function(id) {
        service.show("week-" + id);
        service.show("header-" + id);
        for (var i = 1; i <= 7; i++) {
            service.show("day-" + id + "-" + i)
        }
    };

    service.hideDays = function(id) {
        service.hide("header-" + id);
        for (var i = 1; i <= 7; i++) {
            service.hide("day-" + id + "-" + i)
        }
    };
    return service;
});