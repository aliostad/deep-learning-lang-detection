"use strict";
function __export(m) {
    for (var p in m) if (!exports.hasOwnProperty(p)) exports[p] = m[p];
}
var AEntity_1 = require("./Entity/AEntity");
exports.Model = AEntity_1.Model;
var UrlService_1 = require("./service/UrlService");
exports.UrlService = UrlService_1.UrlService;
var AjaxService_1 = require("./service/AjaxService");
exports.AjaxService = AjaxService_1.AjaxService;
var EntityManager_1 = require("./service/EntityManager");
exports.EntityManager = EntityManager_1.EntityManager;
var Flashmessage_1 = require("./service/Flashmessage");
exports.FlashmessageService = Flashmessage_1.FlashmessageService;
var RepositoryService_1 = require("./service/RepositoryService");
exports.RepositoryService = RepositoryService_1.RepositoryService;
var StorageService_1 = require("./service/StorageService");
exports.StorageService = StorageService_1.StorageService;
var AuthService_1 = require("./service/AuthService");
exports.AuthService = AuthService_1.AuthService;
__export(require("./service/LoginService"));
String.prototype['ucFirst'] = function () {
    return this.charAt(0).toUpperCase() + this.slice(1);
};
