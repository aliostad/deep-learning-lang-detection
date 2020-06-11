/**
 * Created with JetBrains WebStorm.
 * User: Administrator
 * Date: 13-3-14
 * Time: 下午7:23
 * To change this template use File | Settings | File Templates.
 */



var stageShowView = {

    getOLdShow:function (type) {

        var text = $("#stageShow").text();
        if (text == "") {
            return {};
        } else {
            var all = JSON.parse(text);
            var typeValue = all[type];
            ;
            return typeValue;
        }


    },
    init:function () {
        var shows = stageShowView.getOLdShow("login");
        var content = "";
        for (var index in shows) {
            var show = shows[index];
            content = content + show + ",";
        }
        $("#stageShow").hide();
        stageShowView.viewShow(shows);

        $("#showTags").val(content);
        stageShowView.viewStatus();


    },
    viewShow:function (shows) {
        var name=stageShowView.getUserName();
        for (var index in shows) {
            var show = shows[index];
            $("#showArea").append("<p>玩家 [" +name+"] "+ show + " 进入了房间</p>");
        }
    },
    getNewShow:function () {
        var content = $("#showTags").val();
        var cs = content.split(",");
        var shows = {};
        var arrays = [];
        for (var index in cs) {
            var show = cs[index];
            arrays.push(show);

        }
        shows["login"] = arrays;
        return  JSON.stringify(shows);
        ;
    },
    editStatus:function () {
        $("#showEditContainer").show();
        $("#editShow").hide();
    },
    viewStatus:function () {
        $("#showEditContainer").hide();
        $("#editShow").show();
    },
    getUserName:function(){
        return $("#name").val();
    }
}
var stageShowService = {
    updateShow:function (show) {
        return ajaxJson("/player/setting.do?", "post", {type:"stageShow", value:show}, null, 5000, "json");
    }
}

$(document).ready(function () {

    headView.highLight("person");

    leftView.highLight("leftNav_stageShow");

    stageShowView.init();


    $("#clearTag").click(function () {
        $('#myTags').tagit('removeAll')
    });

    $("#submitShow").click(function () {
        var value = stageShowView.getNewShow();
        stageShowService.updateShow(value);
        stageShowView.viewStatus();
        window.location.href=window.location.href;
        return true;

    });
    $("#editShow").click(function () {
        stageShowView.editStatus();
    });


    $("#cancel").click(function () {
        stageShowView. viewStatus();
       });


    $('#myTags').tagit({
        maxTags:5, //最大数限制
        singleField:true,
        singleFieldNode:$("#showTags")
    });

})


