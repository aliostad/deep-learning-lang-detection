$(function() {
	var resumeAnchor = $("#resume-wrapper").offset().top - 80;
	
	var educationAnchor = $("#education-wrapper").offset().top - 80;
	
	var experienceAnchor = $("#experience-wrapper").offset().top - 80;
	
	var skillsAnchor = $("#skills-wrapper").offset().top - 80;
	
	var contactAnchor = $("#contact-wrapper").offset().top - 80;
	
	var $w = $(window).scroll(function(){
		if( $w.scrollTop() > resumeAnchor){ 
			$("#nav-2").addClass("nav-selected");
			$("#nav-2 a").addClass("bold-text");
			
			$("#nav-3").removeClass("nav-selected");
			$("#nav-3 a").removeClass("bold-text");
			
			$("#nav-4").removeClass("nav-selected");
			$("#nav-4 a").removeClass("bold-text");
			
			$("#nav-5").removeClass("nav-selected");
			$("#nav-5 a").removeClass("bold-text");
			
			$("#nav-6").removeClass("nav-selected");
			$("#nav-6 a").removeClass("bold-text");
		}
		else{
			$("#nav-2").removeClass("nav-selected");
			$("#nav-2 a").removeClass("bold-text");
		}
		
		if( $w.scrollTop() > educationAnchor){ 
			$("#nav-3").addClass("nav-selected");
			$("#nav-3 a").addClass("bold-text");
			
			$("#nav-2").removeClass("nav-selected");
			$("#nav-2 a").removeClass("bold-text");
			
			$("#nav-4").removeClass("nav-selected");
			$("#nav-4 a").removeClass("bold-text");
			
			$("#nav-5").removeClass("nav-selected");
			$("#nav-5 a").removeClass("bold-text");
			
			$("#nav-6").removeClass("nav-selected");
			$("#nav-6 a").removeClass("bold-text");			
		}
		else{
			$("#nav-3").removeClass("nav-selected");
			$("#nav-3 a").removeClass("bold-text");
		}
		
		if( $w.scrollTop() > experienceAnchor){ 
			$("#nav-4").addClass("nav-selected");
			$("#nav-4 a").addClass("bold-text");
			
			$("#nav-3").removeClass("nav-selected");
			$("#nav-3 a").removeClass("bold-text");
			
			$("#nav-2").removeClass("nav-selected");
			$("#nav-2 a").removeClass("bold-text");
			
			$("#nav-6").removeClass("nav-selected");
			$("#nav-6 a").removeClass("bold-text");			
		}
		else{
			$("#nav-4").removeClass("nav-selected");
			$("#nav-4 a").removeClass("bold-text");
		}
		
		if( $w.scrollTop() > skillsAnchor){ 
			$("#nav-5").addClass("nav-selected");
			$("#nav-5 a").addClass("bold-text");
			
			$("#nav-3").removeClass("nav-selected");
			$("#nav-3 a").removeClass("bold-text");
			
			$("#nav-2").removeClass("nav-selected");
			$("#nav-2 a").removeClass("bold-text");
			
			$("#nav-6").removeClass("nav-selected");
			$("#nav-6 a").removeClass("bold-text");			
		}
		else{
			$("#nav-5").removeClass("nav-selected");
			$("#nav-5 a").removeClass("bold-text");
		}
		
		if( $w.scrollTop() > contactAnchor){ 
			$("#nav-6").addClass("nav-selected");
			$("#nav-6 a").addClass("bold-text");
			
			$("#nav-3").removeClass("nav-selected");
			$("#nav-3 a").removeClass("bold-text");
			
			$("#nav-4").removeClass("nav-selected");
			$("#nav-4 a").removeClass("bold-text");
			
			$("#nav-5").removeClass("nav-selected");
			$("#nav-5 a").removeClass("bold-text");
			
			$("#nav-2").removeClass("nav-selected");
			$("#nav-2 a").removeClass("bold-text");
		}
		else{
			$("#nav-6").removeClass("nav-selected");
			$("#nav-6 a").removeClass("bold-text");
		}
	});
});