var Const = require("../constants/PixelatorConstants");

module.exports = {
toggleBrushes: function() {
    this.dispatch(Const.TOGGLE_BRUSHES);
},
toggleColors: function() {
    this.dispatch(Const.TOGGLE_COLORS);
},
toggleRGBHSV: function() {
    this.dispatch(Const.TOGGLE_RGB_HSV);
},
changeColor: function(c) {
    this.dispatch(Const.CHANGE_COLOR, c);
},
newColor: function(c) {
    this.dispatch(Const.NEW_COLOR, c);
},
selectColor: function(cid) {
    this.dispatch(Const.SELECT_COLOR, cid);
},
deleteColor: function() {
    this.dispatch(Const.DELETE_COLOR);
}




};
