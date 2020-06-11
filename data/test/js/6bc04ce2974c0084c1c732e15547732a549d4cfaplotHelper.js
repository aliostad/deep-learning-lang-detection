var techTree = (function(api){
    api.orientNodes = function(d, depths){
        switch(api.settings.nodeOrientation){
            case "vertical":
                api.orientNodes.vertical(d, depths);
                break;
            case "horizontal":
                api.orientNodes.horizontal(d, depths);
                break;
            case "circular":
                api.orientNodes.circular(d, depths);
                break;
            default:
                api.orientNodes.vertical(d, depths);
                break;
        }
        api.orientLinks();
    };
    api.orientNodes.horizontal = function(d, depths){
        d.x = d.depth * api.dimensions.nodeOuterHeight;
        d.y = d._depthElementCount * api.dimensions.svgHeight/(depths[d.depth]+1) -
            api.dimensions.nodeInnerHeight/2;
    };
    api.orientNodes.vertical = function(d, depths){
        d.x = d.columnNumber * api.dimensions.svgWidth/6 -
            api.dimensions.nodeInnerWidth/2;
        d.y = d.depth * api.dimensions.nodeOuterHeight;
    };
    api.orientNodes.circular = function(d, depths){
        d.x = api.dimensions.svgWidth/2 -
            api.dimensions.nodeInnerWidth/2 +
            120*d.depth*Math.cos(2*d._depthElementCount*Math.PI/depths[d.depth]);
        d.y = api.dimensions.svgHeight/2 -
            api.dimensions.nodeInnerHeight/2 +
            120*d.depth*Math.sin(2*Math.PI*d._depthElementCount/depths[d.depth]);//d.depth * api.dimensions.nodeOuterHeight;
    };
    api.orientLinks = function(){
        switch(api.settings.nodeOrientation){
            case "vertical":
                api.lineFunction = api.orientLinks.vertical;
                break;
            case "horizontal":
                api.lineFunction = api.orientLinks.horizontal;
                break;
            case "circular":
                api.lineFunction = api.orientLinks.horizontal;
                break;
            default:
                api.lineFunction = api.orientLinks.vertical;
                break;
        }
    };
    api.orientLinks.horizontal = d3.svg
        .diagonal()
        .source(function(d) { return {x:d.source.y, y:d.source.x}; })
        .target(function(d) { return {x:d.target.y, y:d.target.x}; })
        .projection(function(d) {
                    return [d.y+ api.dimensions.nodeInnerHeight/2,
                        d.x + api.dimensions.nodeInnerWidth/2];
        });
    api.orientLinks.vertical = d3.svg
        .diagonal()
        .projection(function (d) {
            return [d.x+ api.dimensions.nodeInnerWidth/2,
                d.y + api.dimensions.nodeInnerHeight/2];
        }
    );
    return api;
}(techTree || {}));
