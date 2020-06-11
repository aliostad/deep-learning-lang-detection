// Hide NSFW
var HideNSFW = (function ($) {
	var show_nsfw = false, link,
		linkText = function () {
			return (show_nsfw ? 'Hide' : 'Show') + ' NSFW';
		},
		getClass = function () {
			return show_nsfw ? '.down' : '.up';
		};
	kango.invokeAsync('kango.storage.getItem', 'show_nsfw', function (show) {
		var old_show = show_nsfw;
		if (show !== null) {
			show_nsfw = show;
			if (old_show !== show_nsfw && link) {
				link.text(linkText());
			}
		}
	});
	return {
		init: function (app) {
			var items = document.getElementsByClassName('nsfw-stream-item'),
				item_count = items.length,
				toggle_nsfw = function (items) {
					$(items).find(getClass() + ':first').each(function () {
						this.click();
					});
				};
			link = $('<a href="#" id="toggle_nsfw" />')
					.text(linkText());
			link.click(function (e) {
				e.preventDefault();
				show_nsfw = !show_nsfw;
				kango.invokeAsync('kango.storage.setItem', 'show_nsfw', show_nsfw);
				$(this).text((show_nsfw ? 'Hide' : 'Show') + ' NSFW');
				toggle_nsfw(items);
			});
			app.addItem(link);
			toggle_nsfw(items);
			setInterval(function () {
				var new_count = items.length;
				if (!show_nsfw && (new_count > item_count)) {
					toggle_nsfw(items);
				}
				item_count = new_count;
			}, 300);
		}
	};
})(window.jQuery);