var Q = require('q');

var showcallback = function(i, callback) {
	console.log('SHOW: ', i);
	return callback(i+1);
}

// show 함수를 q 라이브러리를 활용해 promise 패턴 함수로 만드는 방법
var show = function(i) {
	var deferred = Q.defer();
	showcallback(i, function(j) {
		 deferred.resolve(j);
	});
	return deferred.promise;
}

return show(1)
	.then(function(i) {
		return show(i);
	})
	.then(function(i) {
		return show(i);
	})
	.then(function(i) {
		return show(i);
	})
	.then(function(i) {
		return show(i);
	})
	.then(function(i) {
		return show(i);
	})
	.then(function(i) {
		return show(i);
	})
	.then(function(i) {
		return show(i);
	})
	.then(function(i) {
		return show(i);
	})
	.then(function(i) {
		return show(i);
	});