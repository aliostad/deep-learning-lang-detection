navToggled = false;
Template.nav.events({
	'click .mobileNav .toggleNav':function(event){
		event.preventDefault();
		var target = $(event.target);
		var navPanel = target.parent().parent().parent().find('.navContainer');
		console.log(target);

		if(!navToggled){
			navPanel.velocity({
				translateX: '0'
			}, {
				duration: 200,
				complete: function(){
					navToggled = true;
				}},"easeInSine");
		} else {
			navPanel.velocity({
				translateX: '-100%'
			}, {
				duration: 200,
				complete: function(){
					navToggled = false;
				}},"easeInSine");
		}
	},
	'click .navigation a':function(event){
		
		var target = $(event.target);
		var navPanel = $('.navContainer');
		if(navToggled){
			navPanel.velocity({
					translateX: '-100%'
				}, {
					duration: 200,
					complete: function(){
						navToggled = false;
					}},"easeInSine");
			return navToggled;
			}
		
	}
});