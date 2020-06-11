"use strict";

function init() {
    var s = require("events").EventEmitter,
        o = require("../common/log/log.js"),
        e = {},
        t = { showMask: !1, showFooter: !1, showShare: !1, showTabbar: !1 },
        i = Object.assign({}, s.prototype, {
            hideAll: function(s) {
                e[s] || (e[s] = Object.assign({}, t));
                var i = e[s];
                i.showFooter = !1, i.showMask = !1, i.showShare = !1, i.showTabbar = !1, o.info("leftviewStores.js hideAll " + s + " " + JSON.stringify(i)), this.emit("LEFT_STATUS_UP_" + s, s, e[s], !0)
            },
            clickRightHeader: function(s) { e[s] || (e[s] = Object.assign({}, t)), e[s].showShare || (e[s].showFooter = !e[s].showFooter, e[s].showMask = e[s].showFooter, o.info("leftviewStores.js clickRightHeader " + s + " " + JSON.stringify(e)), this.emit("LEFT_STATUS_UP_" + s, s, e[s])) },
            upShareStatus: function(s, t) {
                var i = e[s];
                e[s].showShare = t, i.showFooter = !1, i.showMask = t, o.info("leftviewStores.js upShareStatus " + s + " " + JSON.stringify(i)), this.emit("LEFT_STATUS_UP_" + s, s, e[s])
            },
            clickMask: function(s) {
                var t = e[s];
                t.showShare || (t.showFooter = !1, t.showMask = !1, t.showShare = !1, o.info("leftviewStores.js clickMask " + s + " " + JSON.stringify(t)), this.emit("LEFT_STATUS_UP_" + s, s, e[s]))
            }
        });
    _exports = i
}
var _exports;
init(), module.exports = _exports;
