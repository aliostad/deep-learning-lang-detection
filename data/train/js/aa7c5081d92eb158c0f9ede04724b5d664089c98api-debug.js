define("api",[],function(require, exports, module) {
    require('jquery');

    //
    API.URL = {};

    //base url
    API.URL.host = "";
    API.URL.url_api = API.URL.host+"api/";
    API.URL.api_appendix = ".json";
    API.URL.url_web = API.URL.host+"";

    //api url
    API.URL.url_get_templete = API.URL.url_api+"get_templete"+API.URL.api_appendix;
    API.URL.url_get_templete_category = API.URL.url_api+"get_templete_category"+API.URL.api_appendix;
    API.URL.url_get_templete_list = API.URL.url_api+"get_templete_list"+API.URL.api_appendix;
    API.URL.url_get_picture_category = API.URL.url_api+"get_picture_category"+API.URL.api_appendix;
    API.URL.url_get_picture_list = API.URL.url_api+"get_picture_list"+API.URL.api_appendix;
    API.URL.url_upload_picture = API.URL.url_api+"upload_picture"+API.URL.api_appendix;
    API.URL.url_generate_templete = API.URL.url_api+"generate_templete"+API.URL.api_appendix;

    // instruction
    function API() {
        this._init();
    }

    module.exports = API;

    API.prototype._init = function() {
        return this;
    };

    API.URL.getTempletePage = function(templete_id){
        return API.URL.url_web + "?id="+templete_id;
    };
});

