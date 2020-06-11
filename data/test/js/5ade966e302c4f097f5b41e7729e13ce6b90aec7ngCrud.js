app.service('ngCrud', function ($http) {
    var apiAddress = "http://localhost:58519/";
    //get one
    this.get = function (api, tbl_obj) {
        return $http.get(apiAddress+"/api/" + api + "/" + tbl_obj);
    }
    //get all
    this.getall = function (api) {
        return $http.get(apiAddress + "/api/" + api)
    }
    //create
    this.post = function (api, tbl_obj) {
        var req = $http({
            method: "post",
            url: apiAddress + "/api/" + api,
            data: tbl_obj
        })
    }
    //update
    this.put = function (api, tbl_obj, id) {
        var request = $http({
            method: "put",
            url: apiAddress + "/api/" + api + "/" + id + "/" + tbl_obj,
            data:tbl_obj
        });
        return request;
    }
    //delete
    this.delete = function (api, id) {
        var request = $http({
            method: "delete",
            url: apiAddress + "/api/" + api + "/" + id
        })
    }
});