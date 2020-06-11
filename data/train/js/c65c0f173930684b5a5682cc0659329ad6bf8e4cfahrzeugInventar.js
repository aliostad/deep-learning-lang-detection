;

var fzInventar = {};

(function($, document, window, ctx, undefined) {
    
    fzInventar.handleSidebarNav = function(subNav) {
        if(subNav !== "") {
            $("#sideNav ul.nav li").each(function(i) {
               var navName = $(this).data("nav-name");
               
               if(navName != undefined && navName === subNav){
                   $(this).addClass("active");
                   return false;
               }
            });
        }
    };
    
})(jQuery, document, window, fzInventar);
