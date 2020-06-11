
// global variables
$navOverlayTrigger = $(".nav-overlay-trigger");
$navOverlayTriggerQuiz = $(".nav-overlay-trigger-quiz");
$navOverlayTriggerIndex = $(".nav-index-trigger");
$navOverlay = $(".nav-overlay");
$navOverlayTriggerClose = $(".nav-overlay-trigger-close");
$body = $("body");
$floatingButton = $(".button");

$navLectures = $(".nav-lectures");
$navExercises = $(".nav-exercises");
$navQuiz = $(".nav-quizzes");
$navIndex = $(".nav-index");

// navigation toggle add & remove
$($navOverlayTrigger).click(function() {
	$navLectures.addClass('nav-open');
	$navLectures.addClass('.bounceOutUp');
	$body.css('overflow', 'hidden');
});

$($navOverlayTriggerQuiz).click(function() {
  $navQuiz.addClass('nav-open');
  $navQuiz.addClass('.bounceOutUp');
  $body.css('overflow', 'hidden');
});

$($navOverlayTriggerIndex).click(function() {
  $navIndex.addClass('nav-open');
  $navIndex.addClass('.bounceOutUp');
  $body.css('overflow', 'hidden');
});

$($navOverlayTriggerClose).click(function() {
	$navLectures.removeClass('nav-open');
	$navExercises.removeClass('nav-open');
  $navQuiz.removeClass('nav-open');
  $navIndex.removeClass('nav-open');
	$body.css('overflow', 'auto');
});

$($floatingButton).click(function() {
	$navExercises.addClass('nav-open');
	$body.css('overflow', 'hidden');
});

$(".scroll-and-overlay-close").click(function(event){
       event.preventDefault();
       //calculate destination place
       var dest=0;
       if($(this.hash).offset().top > $(document).height()-$(window).height()){
            dest=$(document).height()-$(window).height();
       }else{
            dest=$(this.hash).offset().top;
       }
       //go to destination
        $navLectures.removeClass('nav-open');
        $navExercises.removeClass('nav-open');
        $navQuiz.removeClass('nav-open');
        $navIndex.removeClass('nav-open');
        $body.css('overflow', 'auto');
       $('html,body').animate({scrollTop:dest}, 1000,'swing');
 });


$(".scroll").click(function(event){
       event.preventDefault();
       //calculate destination place
       var dest=0;
       if($(this.hash).offset().top > $(document).height()-$(window).height()){
            dest=$(document).height()-$(window).height();
       }else{
            dest=$(this.hash).offset().top;
       }
       //go to destination
       $('html,body').animate({scrollTop:dest}, 1000,'swing');
 });