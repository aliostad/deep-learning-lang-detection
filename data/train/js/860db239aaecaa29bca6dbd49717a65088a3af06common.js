/**
 * Created by Viktoria on 14.11.2014.
 */
'use strict';

$(function(){
    var $navBar = $('#navbar'),
        articlesSubMenuClass = 'articles',
        navBarIsHide = false,
        showFlagClass = 'showFlag',
        mainContentClass = '.main-content',
        mainContentMargin = $(mainContentClass).css('margin-top').replace('px','');

    function showFullNavBar($nav) {
        if (navBarIsHide) {
            navBarIsHide = false;
            $nav.css({ top: '0'});
            $nav.removeClass(showFlagClass);
        }
    }

    function hideNavBar($nav) {
        var height = Math.max($nav.outerHeight(), $nav.find('.container-fluid').outerHeight());
        if (!navBarIsHide) {
            navBarIsHide = true;
            $nav.css({ top: '-' + height + 'px' });
            $nav.addClass(showFlagClass);
        }
    }

    function showArticlesSubMenu(){
        if($navBar.hasClass(articlesSubMenuClass)){
            $navBar.removeClass(articlesSubMenuClass);
        }else{
            $navBar.addClass(articlesSubMenuClass);
        }
    }

    $('#articles-menuitem').on('click', showArticlesSubMenu);

    $(document).mousemove(function (e) {
        var mouseY = e.pageY || e.clientY || 0;

        if (mouseY < $navBar.height()) {
            showFullNavBar($navBar);
        }
    }, false);

    $(window).scroll(function () {
        var sc = ($(this).scrollTop() > $navBar.height())?
            (function(){hideNavBar($navBar); $(mainContentClass).css('margin-top', '0');})():
            (function(){showFullNavBar($navBar); $(mainContentClass).css('margin-top', mainContentMargin + 'px');})();
    });

    $navBar.mouseout(function (e) {
        if ($(window).scrollTop() > $navBar.height()) {
            hideNavBar($navBar);
        }
    });

    $navBar.mouseover(function (e) {
        if ($(window).scrollTop() > $navBar.height()) {
            showFullNavBar($navBar);
        }
    });
});

var updateOperations = {
    'edit': "EDIT",
    'delete': "DELETE"
};