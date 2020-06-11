(function(root){
    "use strict";

    function range(x, xMin, xMax) {
        return x < xMin ? xMin : (x > xMax ? xMax : x);
    }

    root.createViewport = function(canvasGrid) {

        var api = {
            canvasGrid: canvasGrid,
            x: 0,
            y: 0,
            target: {}
        };

        api.setTarget = function(canvas) {
            api.target.canvas = canvas;
            return api;
        }

        api.setViewportSize = function(w, h) {
            api.w = w;
            api.h = h;

            api.target.w = (api.x + w) < api.canvasGrid.pixelWidth ? w : api.canvasGrid.pixelWidth - api.x;
            api.target.h = (api.y + h) < api.canvasGrid.pixelHeight ? h : api.canvasGrid.pixelHeight - api.y;

            return api;
        };

        api.draw = function() {
            api.canvasGrid.renderTo(api.target.canvas, api.x, api.y, api.target.w, api.target.h);
        };

        return api;
    };

})(module.exports);
