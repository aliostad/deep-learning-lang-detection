/*
Shows filtered tables in "View More" navigation item.
*/
			$(function(){
			
			$('#null').addClass('show').click(function(){
			$(this).addClass('show');
			});
			
			$('a.first-child-a').click(function() {
				$('#null.show').show().siblings().hide();
			});	
			
			$('a.viewall').click(function() {
				$('#null.show').show().siblings().hide();
			});	
			
			$('#tech').addClass('show').click(function(){
			$(this).addClass('show');
			});
			
			$('a.tech').click(function() {
				$('#tech.show').show().siblings().hide();
			});		
			
			
			$('#performance').addClass('show').click(function(){
			$(this).addClass('show');
			});
			
			$('a.performance').click(function() {
				$('#performance.show').show().siblings().hide();
			});		
			
			$('#learning').addClass('show').click(function(){
			$(this).addClass('show');
			});
			
			$('a.learning').click(function() {
				$('#learning.show').show().siblings().hide();
			});		
			
			$('#difficulty').addClass('show').click(function(){
			$(this).addClass('show');
			});
			
			$('a.difficulty').click(function() {
				$('#difficulty.show').show().siblings().hide();
			});		
				
			});


/*
Shows appropriate content in About This Item navigation, based on a value in the URL.
*/


		$(function() {
    if (location.href.match(/\math1/)) {
        $('div#math1').show().siblings().hide();
     }
    else if (location.href.match(/\math2/)) {
        $('div#math2').show().siblings().hide();
     }
    else {
        $('div#generic').show().siblings().hide();
     }
		});
		