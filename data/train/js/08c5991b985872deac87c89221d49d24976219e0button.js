(function() {
	tinymce.PluginManager.add('my_mce_button', function( editor, url ) {
		editor.addButton('my_mce_button', {
			text: '[members]',
			icon: false,
			onclick: function() {
				editor.insertContent('[members style="default" size="box" sorter="false" map_view="false" border_style="" columns="3" color="#1972DD" team="" show_count="-1" member_id="" show_bio="true" show_quote="true" show_phone="true" show_email="true" show_website="true" show_location="true" show_map="true" show_social="true" show_twitter="true" show_skills="true"]');
			}
		});
	});
})();