/* Author:

*/

$(document).ready(function() {
	showRSS();
});

function showData(data) {
	  $('#admin_space').html(data);	
}

function showURL() {
	$.get('/url', showData);
}

function showDropbox() {
	$.get('/dropbox', showData);
}

function showRSS() {
	$.get('/rss', showData);	
}

function showAdminLogin() {
	$.get('/admin_login', showData);
}

function showPlugins() {
	$.get('/plugins', showData);
}

function showEditor() {
	$.get('/editor.html', showData);
}

function update() {
	showData('Updating your blog... (This might take a while)');
	$.get('/update_blog', showData);
}