/**
 *游戏的关于方块变换的部分
 *移动和旋转函数
 *@author:Waterbear
 */



/**
 *全局变量
 *@Gamemap:游戏地图
 *@points:方块的坐标
 * */

var Service = {
    GameMap:null,
    points:null,
    nowType:null,
    nextType:null
};

/****游戏中的二维数组保存着地图****/



/******初始化地图*******/

var mapInit = function() {
    Service.GameMap = new Array();
    for(var i = 0; i < 12; ++i){
        Service.GameMap[i] = new Array();
        for(var j = 0; j < 18; ++j){
            Service.GameMap[i][j] = false;
        }
    }

};

/****判断是否超出了地图*****/

var isOverMap = function(x,y) {
    return x < 0 || x > 11 || y < 0 || y > 17 || Service.GameMap[x][y];
};

/****移动函数*****/

var move = function(moveX,moveY) {
    for(var i = 0; i < Service.points.length; i++){
        var nowX = Service.points[i].x + moveX;
        var nowY = Service.points[i].y + moveY;
        if(this.isOverMap(nowX, nowY)){
            return false;
        }
    }

    for(var i = 0; i < Service.points.length; i++){
        Service.points[i].x += moveX;
        Service.points[i].y += moveY;
    }

  //调用draw.js文件中的初始化函数,进行重绘

    InitcvsGame(Service.GameMap,Service.points,Service.nowType);

    return true;

};


/*****旋转函数******/

var Rotate = function() {

    //类型是4不能旋转

    if(Service.nowType === 4){
        return;
    }

    //用笛卡尔坐标进行旋转

    for(var i = 1; i < Service.points.length; i++){
        var nowX = Service.points[0].y + Service.points[0].x - Service.points[i].y;
        var nowY = Service.points[0].y - Service.points[0].x + Service.points[i].x;
        if(isOverMap(nowX, nowY)){
            return;
        }
    }
    for(var i = 1; i < Service.points.length; i++){
        nowX = Service.points[0].y + Service.points[0].x - Service.points[i].y;
        nowY = Service.points[0].y - Service.points[0].x + Service.points[i].x;
        Service.points[i].x = nowX;
        Service.points[i].y = nowY;
    }

    InitcvsGame(Service.GameMap,Service.points,Service.nowType);
};

/****初始化要显示方块的函数***/

var InitAct = function() {

    //调用diamonds.js文件中的diaPoint函数

    Service.points = new diaPoint(Service.nowType);

}

/****返回整个service对象****/

var getService = function() {
    return Service;
}






