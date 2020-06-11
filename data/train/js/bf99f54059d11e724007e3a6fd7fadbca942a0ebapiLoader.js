var fs = require("fs");

function load() {
    var apis = fs.readdirSync("./api");
    var re = [];
    for(var i = 0; i < apis.length; i++) {
        var api = apis[i];
        var api_config = fs.readFileSync("./api/" + api + "/api.json", {"encoding": "utf-8"});
        api_config = JSON.parse(api_config);

        if(api_config.autoload) {
            re.push({"name": api, "api": 'require("../api/' + api + '/index.js")'});
        }
    }

    return re;
}

function getApi(apiName) {
    return require("../api/" + apiName + "/index.js");
}

module.exports = {load: load, getApi: getApi};