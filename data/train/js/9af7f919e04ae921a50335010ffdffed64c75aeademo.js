var mySlideShow;

window.addEvent('domready',function(){
	
	// instance with a few options
	mySlideShow = new SlideShow('slides',{
		delay: 3000,
		autoplay: false
	});
	
	// the rest of the demo showing how to control the instance
	var toggled = [$('show'), $('showNext'), $('showPrevious'), $('showIndex')];
	
	$('show0').addEvent('click',function(){
		mySlideShow.show(0);
	});
	
	$('show1').addEvent('click',function(){
		mySlideShow.show(1);
	});

	$('show2').addEvent('click',function(){
		mySlideShow.show(2);
	});

  $('show3').addEvent('click',function(){
		mySlideShow.show(3);
	});

  $('showNext').addEvent('click',function(){
		mySlideShow.showNext();
	});

	$('showNext1').addEvent('click',function(){
		mySlideShow.showNext();
	});

	$('showNext2').addEvent('click',function(){
		mySlideShow.showNext();
	});

  $('showPrevious').addEvent('click',function(){
		mySlideShow.showPrevious();
	});


	$(document).addEvent('keyup', function(event){
		if(event.key == 'left')
			mySlideShow.showPrevious();
		else if (event.key == 'right')
			mySlideShow.showNext();
	});


});
