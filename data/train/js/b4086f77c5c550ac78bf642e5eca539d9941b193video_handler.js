var video = {
	css : {
		show_video:function(id){
			$('.cover-v').show();
			$('#video'+id).addClass('show-video');
			$('#cv'+id).addClass('show-video');
			$('.close-video').show().attr('id',''+id);
			$('.upside-header').hide();
		},
		hide_video:function(){
			$('.cover-v').hide();
			$('.video').removeClass('show-video');
			$('.video_comment_cover').removeClass('show-video');
			$('.close-video').hide().removeAttr('id');
			$('.upside-header').show();
		}
	}
}

$('.cover-v').on('click',function(){
	video.css.hide_video();
});
