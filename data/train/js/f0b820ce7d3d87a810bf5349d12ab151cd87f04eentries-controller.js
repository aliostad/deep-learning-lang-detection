(function() {
	angular.module('MyEntries').controller('EntriesController', ['Entry', '$sce', function(Entry, $sce) {
		var controller = this;
		var len = 200;
		Entry.getAll().success(function(data) {
			controller.entries = data;
			for (var i = 0; i < controller.entries.length; i++) {
				if (controller.entries[i].content.length > 200) {
					var link = '/#/' + controller.entries[i].id;
					controller.entries[i].content = controller.entries[i].content.substr(0, len) + '<a href="' + link + '">...</a>';
				}
				controller.entries[i].content = $sce.trustAsHtml(controller.entries[i].content);
			}
		});
	}]);
})();