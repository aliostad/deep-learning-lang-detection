/* globals describe, it, beforeEach */

var ShowRSS = require('../lib/ShowRSS');
var assert = require('assert');

describe('ShowRSS', function(){

	var showRSS;
	
	beforeEach(function(){
		showRSS = new ShowRSS({});
	});
	
	describe('refeshShowList', function(){
	
		it('should populate the show list', function(done){
		
		
			showRSS.refreshShowList(function(err){
				
				assert(!err, 'No error');
				
				assert.equal(showRSS.shows['4'], 'American Dad!');
				assert.equal(showRSS.shows['483'], 'Revolution');
				
				done();
			});
			
		});
			
	});
	
});

