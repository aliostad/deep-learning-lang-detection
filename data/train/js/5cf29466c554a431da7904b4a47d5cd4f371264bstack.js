$().ready(function() {
    var width = $(window).width();
    if (width<768) {
        $('.nav-tabs').addClass('nav-stacked');
        $('.nav-pills').addClass('nav-stacked');
        $('.bs-table-toolbar').addClass('btn-group-vertical');
    }
    else {
        $('.nav-tabs').removeClass('nav-stacked');
        $('.nav-pills').removeClass('nav-stacked');
        $('.bs-table-toolbar').removeClass('btn-group-vertical');
    }
});
$(window).resize(function() {
    var width = $(window).width();
    if (width<768) {
        $('.nav-tabs').addClass('nav-stacked');
        $('.nav-pills').addClass('nav-stacked');
        $('.bs-table-toolbar').addClass('btn-group-vertical');
    }
    else {
        $('.nav-tabs').removeClass('nav-stacked');
        $('.nav-pills').removeClass('nav-stacked');
        $('.bs-table-toolbar').removeClass('btn-group-vertical');
    }
});