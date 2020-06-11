
define(['exports','web/storageWebApi'], function (exports,sessionApi) {
    var WebApi = sessionApi.SessionApi;
    var DataApi = (function () {
        var DataApi = function (url) {
            this.baseUrl = url;

        }
        var DataApiInstance = null;
        DataApi.getInstance = function (url) {
            if (!DataApiInstance) {
                DataApiInstance = new DataApi(url);
            }
            return DataApiInstance;

        }

        DataApi.prototype = {
            loadTreeMap: function (url) {
                var path = this.baseUrl + "/webApi/data.js";
                var api = WebApi.getInstance(this.baseUrl);
                return api.getJsonData(path);
            }
        }
        return DataApi;
    })();

    exports.DataApi = DataApi;
}); 