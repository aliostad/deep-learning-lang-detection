function sns_person_space_header(){
	this.show_person_space_nav();
};

sns_person_space_header.prototype.show_person_space_nav = function(){
	var me = this;
	$("#show_person_space_nav,#person_space_nav").mouseover(function(){
		me.set_position_show("show_person_space_nav", "person_space_nav");
	});
	
	$("#person_space_nav").mouseleave(function(){
		$(this).hide();
	});
};

sns_person_space_header.prototype.set_position_show = function(id,show_id) {
    var show_x = $("#" + id).outerHeight() + $("#" + id).position().top + 10;
    var show_y = $("#" + id).position().left;
    
    $("#" + show_id).css({
    	"position":"absolute", 
    	"left":show_y + "px", 
    	'top':show_x + "px",
    	'z-index':999
    	}); 
    
    $("#" + show_id).show();
};

$(function(){
	new sns_person_space_header();
});