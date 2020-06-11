/**
 * @author chenshenglong
 */
$('.show-en').on('click',function(){
    $('.ch').hide();
    $('.en').show();
    $('.show-ch').removeClass('active');
    $('.show-both').removeClass('active');
    $(this).addClass('active');
});

$('.show-ch').on('click',function(){
    $('.en').hide();
    $('.ch').show();
    $('.show-en').removeClass('active');
    $('.show-both').removeClass('active');
    $(this).addClass('active');
});

$('.show-both').on('click',function(){
    $('.ch').show();
    $('.en').show();
    $('.show-en').removeClass('active');
    $('.show-both').removeClass('active');
    $(this).addClass('active');
});