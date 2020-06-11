$(function() {
	
	$('#nav-search-text').keyup(function() {
		if($('#quote-list').size() > 0) {
			var stringPart = $('#nav-search-text').val();
			if(stringPart.length >= 2) {
				$('#quote-list').load($('#nav-search-form').attr('action'), $('#nav-search-form').serialize());
			} else {
				$('#quote-list').load($('#nav-search-form').attr('action'));
			}
		}
	});
	
	$('#nav-search-reset').click(function() {
		$('#nav-search-text').val(''); 
		$('#quote-list').load($('#nav-search-form').attr('action'));
		return false;
	});
});