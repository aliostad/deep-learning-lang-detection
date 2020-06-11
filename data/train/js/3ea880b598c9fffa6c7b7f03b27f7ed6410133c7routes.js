var barbakoa = require("barbakoa");
var r = barbakoa.router;

var movieApi = require("./api/movieApi");
var downloadApi = require("./api/downloadApi");
var torrentsApi = require("./api/torrentsApi");
var recentApi = require("./api/recentApi");
var showApi = require("./api/showApi");
var fileApi = require("./api/fileApi");
var playerApi = require("./api/playerApi");
var logsApi = require("./api/logsApi");
var subtitlesApi = require("./api/subtitlesApi");
var favApi = require("./api/favApi");
var searchApi = require("./api/searchApi");
var notificationsApi = require("./api/notificationsApi");

r.get("/", function * () {
  var assets = barbakoa.assets.getModule("app");
  yield this.render("index", {assets: assets});
});

r.get("/api/movies", movieApi.find);
r.get("/api/movies/:imdb", movieApi.get);

r.get("/api/shows", showApi.find);
r.get("/api/shows/:imdb", showApi.get);

r.post("/api/favs/:imdb", favApi.add);
r.delete("/api/favs/:imdb", favApi.remove);

r.get("/api/search", searchApi.search);

r.get("/api/downloads", downloadApi.list);
r.get("/api/downloads/:id/start", downloadApi.start);
r.get("/api/downloads/:id/stop", downloadApi.stop);

r.get("/api/torrents", torrentsApi.list);
r.get("/api/torrents/download/:magnet", torrentsApi.download);

r.get("/api/recent", recentApi.list);

r.get("/api/files", fileApi.find);
r.get("/api/player", playerApi.play);
r.get("/api/logs", logsApi.list);

r.post("/api/subtitles", subtitlesApi.download);


r.get("/api/notifications", notificationsApi.registerDevice);
r.get("/api/notifications/test", notificationsApi.testNotification);