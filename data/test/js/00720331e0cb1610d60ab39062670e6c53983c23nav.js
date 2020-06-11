var nav = {};

// Define.
nav.statusPage = $("#status");
nav.listenersPage = $("#listeners");
nav.logsPage = $("#logs");
nav.settingsPage = $("#settings");
nav.helpPage = $("#help");
nav.aboutPage = $("#about");
nav.menu = $("#menu");
// end of define

nav.goto = function(page, item)
{
    nav.menu.find(".active").removeClass("active").end().find("i").removeClass("icon-white");
    $(".maincontent").hide();
    if (item)
    {
        var jItem = $(item);
        jItem.parent().addClass("active");
        jItem.find("i").addClass("icon-white");
    }
    page.show();
}

nav.switchToWhiteIcon = function(item)
{
    $(item).find("i").addClass("icon-white");
}

$("#status_link").live("click", function(){
   nav.goto(nav.statusPage, this);
})

$("#svnrepos_link").live("click", function(){
   nav.goto(nav.listenersPage, this);
})

$("#logs_link").live("click", function(){
   nav.goto(nav.logsPage, this);
   Logs.listRepositories();
})

$("#settings_link").live("click", function(){
   nav.goto(nav.settingsPage, this);
})

$("#help_link").live("click", function(){
   nav.goto(nav.helpPage, this);
})

$("#about_link").live("click", function(){
   nav.goto(nav.aboutPage, this);
})

