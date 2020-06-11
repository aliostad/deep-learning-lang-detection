/**
 * Created by Sam on 14-11-19.
 */
$().ready(function(){
    var $articleContent, $articleH2, $articleNav, $fn_article_nav_toggle, fn_article_nav_right, fn_article_nav_top, fn_article_nav_toggle;

    $articleContent = $('.article-content').eq(0);
    $articleH2 = $articleContent.find('h2');
    $articleContent = $('.article-content').eq(0);
    $articleH2 = $articleContent.find('h2');
    $articleNav = $('#fn_article_nav');
    $fn_article_nav_toggle = $('#fn_article_nav_toggle');
    fn_article_nav_toggle = false;

    function initArticleNavList(){
        var navListHtml = '';
        $articleH2.each(function(i){
            $(this).attr('id','article_nav_' + i);
            navListHtml =
                '<li><a href="#' +$(this).attr('id') + '">' +
                    $(this).html();
            '</a> </li>';
            $articleNav.append(navListHtml);
        })
    };

    //bind fn_article_nav_toggle
    function initArticleNavToggle(){
        $fn_article_nav_toggle.bind('click',function(){
            if(fn_article_nav_toggle){
                $articleNav.removeClass('fn_article_nav_toggle');
                fn_article_nav_toggle = false;
            }else{
                $articleNav.addClass('fn_article_nav_toggle');
                fn_article_nav_toggle = true;
            }
            return false;
        });
    };

    function initArticleOffset(){
        //init article_nav
        fn_article_nav_right = $(window).width() - ($articleContent.offset().left + $articleContent.outerWidth());
        fn_article_nav_top = $articleNav.offset().top ;
    };

    function setArticleNavOffset(){
        if($(document).scrollTop() > fn_article_nav_top){
            $articleNav.css({'position':'fixed', 'right':fn_article_nav_right, 'top':'10px'})
        }else{
            $articleNav.css({'position':'absolute', 'right':0, 'top':'10px'})
        }
    };

    initArticleNavList();
    initArticleNavToggle();
    initArticleOffset();

    $(document).scroll(function(){
        setArticleNavOffset();
    })
    $(window).resize(function(){
        initArticleOffset();
        setArticleNavOffset();
    })

});