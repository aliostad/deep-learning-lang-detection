define('wikipedia_game_data', [], 
	function () {
	'use strict';
	
	var WikipediaBoard = function() {};

	WikipediaBoard.generateData = function(){

		return [
					{val: 5, show: true}, {val: 3, show: true}, {val: 4, show:false},
					{val: 6, show: false}, {val: 7, show: true}, {val: 8, show:false},
					{val: 9, show: false}, {val: 1, show: false}, {val: 2, show: false},
					{val: 6, show: true}, {val: 7, show: false}, {val: 2, show: false},
					{val: 1, show: true}, {val: 9, show: true}, {val: 5, show: true},
					{val: 3, show: false}, {val: 4, show: false}, {val: 8, show: false},
					{val: 1, show: false}, {val: 9, show: true}, {val: 8, show: true},
					{val: 3, show: false}, {val: 4, show: false}, {val: 2, show: false},
					{val: 5, show: false}, {val: 6, show: true}, {val: 7, show: false},
					{val: 8, show: true}, {val: 5, show: false}, {val: 9, show:false},
					{val: 7, show: false}, {val: 6, show: true}, {val: 1, show: false},
					{val: 4, show: false}, {val: 2, show: false}, {val: 3, show: true},
					{val: 4, show: true}, {val: 2, show: false}, {val: 6, show:false},
					{val: 8, show: true}, {val: 5, show: false}, {val: 3, show: true},
					{val: 7, show: false}, {val: 9, show: false}, {val: 1, show: true},
					{val: 7, show: true}, {val: 1, show: false}, {val: 3, show:false},
					{val: 9, show: false}, {val: 2, show: true}, {val: 4, show: false},
					{val: 8, show: false}, {val: 5, show: false}, {val: 6, show: true},
					{val: 9, show: false}, {val: 6, show: true}, {val: 1, show:false},
					{val: 5, show: false}, {val: 3, show: false}, {val: 7, show: false},
					{val: 2, show: true}, {val: 8, show: true}, {val: 4, show: false},
					{val: 2, show: false}, {val: 8, show: false}, {val: 7, show:false},
					{val: 4, show: true}, {val: 1, show: true}, {val: 9, show: true},
					{val: 6, show: false}, {val: 3, show: false}, {val: 5, show: true},
					{val: 3, show: false}, {val: 4, show: false}, {val: 5, show: false},
					{val: 2, show: false}, {val: 8, show: true}, {val: 6, show: false},
					{val: 1, show: false}, {val: 7, show: true}, {val: 9, show: true}
		];
	};
	
	return WikipediaBoard;

});