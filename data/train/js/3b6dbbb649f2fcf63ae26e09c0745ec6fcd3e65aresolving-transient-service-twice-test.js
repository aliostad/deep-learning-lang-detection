
var test = require("tape"),
	Sandal = require('../sandal.js');

test('Resolve service twice', function (t) {

	t.plan(2);

	var sandal = new Sandal();
	var i = 0;
	var service = function () {
		i++;
		this.name = i;
	};
	service.prototype.getName = function() {
		return this.name;
	};
	sandal.service('service', service, 'transient');

	sandal.resolve(function(err, service) {
		t.equal(service.getName(), 1, 'Should get an instance');
	});

	sandal.resolve(function(err, service) {
		t.equal(service.getName(), 2, 'Should get a new instance');
	});

});