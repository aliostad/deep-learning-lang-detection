$(document).ready(function($){

    /**
     * Панель разработчика
     */
    $(".button-show").mousemove(function (eventObject) {
        $("#show_classes") .show();
    }).mouseout(function () {
        $("#show_classes").hide();
    });

    $("#button_show_classes").mousemove(function (eventObject) {
        $("#show_classes") .show();
    }).mouseout(function () {
        $("#show_classes").hide();
    });
    $("#button_show_session").mousemove(function (eventObject) {
        $("#show_session") .show();
    }).mouseout(function () {
        $("#show_session").hide();
    });

    $("#button_show_get").mousemove(function (eventObject) {
        $("#show_get") .show();
    }).mouseout(function () {
        $("#show_get").hide();
    });

    $("#button_show_post").mousemove(function (eventObject) {
        $("#show_post") .show();
    }).mouseout(function () {
        $("#show_post").hide();
    });

    $("#button_show_requests").mousemove(function (eventObject) {
        $("#show_requests") .show();
    }).mouseout(function () {
        $("#show_requests").hide();
    });

    $("#close_table").click(function (eventObject) {
        $var = $("#develop").attr("toggle");
        if($var=="true"){
            $("#develop").hide().attr("toggle", "false");
            $("#develop_button").show();
        }
    });

    $("#develop_button").click(function (eventObject) {
        $var = $("#develop").attr("toggle");
        if($var=="false"){
            $("#develop").show().attr("toggle", "true");
            $("#develop_button").hide();
        }
    });

}); //конец  ready