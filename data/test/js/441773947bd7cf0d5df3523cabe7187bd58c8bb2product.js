$(function(){

// menu select
	
	var boxul_width = $('.cakedisplay').width(),
		boxli_index = 0,
		boxli_count = $('.cakedisplay ul').length; //cs1~3的個數
		// boxli_first = $('.cakedisplay ul:first').clone();

	// console.log(boxul_width * boxli_count);

	// function slidemove(){
	// 	$('.cakesliderholder').stop().animate({left: boxul_width * boxli_index })
	// }

	$('.cakemenubtn1').click(function(){
		$('.cakesliderholder').stop().animate({left: 0})
	});

	$('.cakemenubtn2').click(function(){
		$('.cakesliderholder').stop().animate({left: -1430})
	});

	$('.cakemenubtn3').click(function(){
		$('.cakesliderholder').stop().animate({left: -2820})
	});

	// $('.cake').on('click',function(data){
	// 	$('.cakeDetail').addClass('show');
	// 	$(this).addClass('show');
	// 	$('.black').addClass('show');
	// });

	
// cake03 Detail
	$('.cake03').click(
		function(){
			$('.cakeDetail').addClass('show');
			$('.cakeD03').addClass('show');
			$('.black').addClass('show');
		})
	$(".detailXX").click(
		function(){
			$('.cakeDetail').removeClass('show');
			$('.cakeD03').removeClass('show');
			$('.black').removeClass('show');
		})
	$(".black").click(
		function(){
			$('.cakeDetail').removeClass('show');
			$('.cakeD03').removeClass('show');
			$('.black').removeClass('show');
		})	
// cake04 Detail
	$('.cake04').click(
		function(){
			$('.cakeDetail').addClass('show');
			$('.cakeD04').addClass('show');
			$('.black').addClass('show');
		})
	$(".detailXX").click(
		function(){
			$('.cakeDetail').removeClass('show');
			$('.cakeD04').removeClass('show');
			$('.black').removeClass('show');
		})
	$(".black").click(
		function(){
			$('.cakeDetail').removeClass('show');
			$('.cakeD04').removeClass('show');
			$('.black').removeClass('show');
		})
// cake06 Detail
	$('.cake06').click(
		function(){
			$('.cakeDetail').addClass('show');
			$('.cakeD06').addClass('show');
			$('.black').addClass('show');
		})
	$(".detailXX").click(
		function(){
			$('.cakeDetail').removeClass('show');
			$('.cakeD06').removeClass('show');
			$('.black').removeClass('show');
		})
	$(".black").click(
		function(){
			$('.cakeDetail').removeClass('show');
			$('.cakeD06').removeClass('show');
			$('.black').removeClass('show');
		})	
// cake10 Detail
	$('.cake10').click(
		function(){
			$('.cakeDetail').addClass('show');
			$('.cakeD10').addClass('show');
			$('.black').addClass('show');
		})
	$(".detailXX").click(
		function(){
			$('.cakeDetail').removeClass('show');
			$('.cakeD10').removeClass('show');
			$('.black').removeClass('show');
		})
	$(".black").click(
		function(){
			$('.cakeDetail').removeClass('show');
			$('.cakeD10').removeClass('show');
			$('.black').removeClass('show');
		})	
// cake12 Detail
	$('.cake12').click(
		function(){
			$('.cakeDetail').addClass('show');
			$('.cakeD12').addClass('show');
			$('.black').addClass('show');
		})
	$(".detailXX").click(
		function(){
			$('.cakeDetail').removeClass('show');
			$('.cakeD12').removeClass('show');
			$('.black').removeClass('show');
		})
	$(".black").click(
		function(){
			$('.cakeDetail').removeClass('show');
			$('.cakeD12').removeClass('show');
			$('.black').removeClass('show');
		})	
// cake15 Detail
	$('.cake15').click(
		function(){
			$('.cakeDetail').addClass('show');
			$('.cakeD15').addClass('show');
			$('.black').addClass('show');
		})
	$(".detailXX").click(
		function(){
			$('.cakeDetail').removeClass('show');
			$('.cakeD15').removeClass('show');
			$('.black').removeClass('show');
		})
	$(".black").click(
		function(){
			$('.cakeDetail').removeClass('show');
			$('.cakeD15').removeClass('show');
			$('.black').removeClass('show');
		})	




})