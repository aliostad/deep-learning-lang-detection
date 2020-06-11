$(function() {
	var $content = $('#page-content'),
		$navOpen = $('#navigation .open'),
		navState = (window.location.hash != '#navigation') ? 'open' : 'closed';

	function toggleNav(link) {
		setTimeout(function() {
			if (navState == 'closed') {
				navState = 'open';
				link.setAttribute('href', '#');
				$content.on('click.closenav', function() {
					window.location.hash = '';
					toggleNav(link);
				});
			} else {
				navState = 'closed';
				link.setAttribute('href', '#navigation');
				$content.off('click.closenav');
			}
		}, 0);
	}

	$navOpen.click(function() {
		toggleNav(this);
	});
	toggleNav($navOpen.get(0));
});
