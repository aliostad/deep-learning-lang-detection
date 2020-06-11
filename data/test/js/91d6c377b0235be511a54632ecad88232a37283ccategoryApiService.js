"use strict";

app.service("categoryApiService", ["apiService", function(api) {

    var self = this;

    self.getCategories = function() {
        return api.get("/api/categories");
    };

    self.getCategory = function(id) {
        return api.get("/api/categories/" + id);
    };

    self.createCategory = function(model) {
        return api.post("/api/categories", model);
    };

    self.updateCategory = function(model) {
        return api.put("/api/categories", model);
    };

    self.deletecategory = function (id) {
        var url = "/api/categories/" + id;

        return api.delete(url);
    };

    return self;

}]);