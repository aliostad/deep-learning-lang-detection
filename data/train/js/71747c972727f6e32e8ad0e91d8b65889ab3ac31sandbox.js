(function Test() {
	'use strict';

	eval(uate)('Testing');

	/**
	 * Testings.
	 *
	 * @param {String} foo
	 * @param {Object} bar
	 */
	window.x = function (foo, bar) {
		// blue
		var y = {};
	};

	/**
	 * My funny function
	 *
	 * @param {String} test
	 * @return {boolean} whaterver
	 */
	/*
	function funny(str) {
		return !!str;
	}

	//var closure = TestAPI;
	//console.log(eval(uate)(funny));
	//debugger; eval(uate)(obj, closure)
	//debugger; // Why is TestAPI not visible

	// This is x
	var x = {
	
	};

	x['.y (z)'] = function () {
		// tested
		this.tested = function () {
			// This tested2 = 3;
			this.tested2 = 3;
		};
		// test
		var test = 1;

		eval(uate)(this);
		eval(uate)(x);
		eval(uate)(test);
	};
	*/

	//x['.y (z)']();

	/*
	// TestAPI
	// TestAPI|a
	// TestAPI|a.b|this.c
	// TestAPI|a.b|test
	// TestAPI|a.b|this.c.d
	// TestAPI|a.b|this.c2
	// TestAPI|a.b|this.c2.d2
	// TestAPI|a.b|this.c2.e
	// TestAPI|a.b|this.c2.e.f
	var a = { b: function () {
		// c
		this.c = 1;
		function test() {}
		this.c.d = 2;
		// d
		this.c2 = {
			d2: 1,
			e: {
				f: null
			}
		};
	}};
	*/

	/*
	// expect:
	// TestAPI
	// TestAPI|a
	// TestAPI|a.b
	// TestAPI|a.b.c
	// TestAPI|a.b.c.d
	var a = {b:{}};
	a.b['c'] = {d: 1};
	*/

	/*
	// TestAPI
	// TestAPI|six
	// TestAPI|seven
	// TestAPI|eight
	// TestAPI|nine
	// TestAPI|nine
	// TestAPI|eight
	// TestAPI|nine
	// TestAPI|ten
	// TestAPI|eleven
	// TestAPI|nine.ten
	function six() {}
	var seven = function () {}
	var eight, nine = 9;
	nine = 10;
	eight, nine;
	var ten, eleven;
	nine.ten = {};
	*/

	/*
	// TODO : new expressions
	// TODO : function arguments
	// expect:
	// TestAPI
	// TestAPI|foo
	// TestAPI|foo|this.bar
	var foo = function () {
		this.bar = 1;
	};
	*/

	/*
	// expect:
	// TestAPI
	// TestAPI|a
	// TestAPI|a|b
	// TestAPI|a|c
	// TestAPI|a|c|d1
	// TestAPI|a|c|d2
	// TestAPI|a|c|d3
	// TestAPI|a|c|this.d4
	// TestAPI|a|c|d5
	function a() {
		b = function () {}
		function c() {
			var d1 = function () {}
			d2 = function () {}
			function d3() {}
			this.d4 = function d5() {}
		}
	}
	*/

	/*
	// expect:
	// TestAPI
	// TestAPI|a
	// TestAPI|a.b
	// TestAPI|a.b.c
	var a = {};
	a.b = { c: null };
	*/

	/*
	// expect:
	// TestAPI
	// TestAPI|a
	// TestAPI|b
	var a, b = undefined;
	*/

	/*
	// expect:
	// TestAPI
	// TestAPI|a
	// TestAPI|b
	// TestAPI|a.c
	// TestAPI|d
	var a = function b() {}
	a.c = function d() {}
	*/

}());
