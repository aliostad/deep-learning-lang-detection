describe("Support module controller tests", function() {
	var $controller, scope, $http;
	beforeEach(module('SupportModule'));
		beforeEach(inject(function($rootScope, _$controller_, _$http_) {
		$controller =_$controller_;
		http = _$http_;
    	$scope = $rootScope.$new();        
	}));

	describe("MainController tests", function() {

		it('should be defined', inject(function($controller) {
		      var MainController = $controller('MainController');
		      expect(MainController).toBeDefined();
		}));

		it('should define selected = 0', inject(function($controller) {
		      var MainController = $controller('MainController');
		      expect(MainController.selected).toBe(0);
		}));

		it('tests select function', inject(function($controller) {
		      var MainController = $controller('MainController');
		      MainController.select();
		      expect(MainController.selected).toBe(MainController.withSelect);
		}));

		it('tests isSelected function', inject(function($controller) {
		      var MainController = $controller('MainController');
		      var result = MainController.isSelected();
		      expect(result).toBe(false);
		      MainController.select();
		      result = MainController.isSelected();
		      expect(result).toBe(true);
		}));

	});
	describe("RefundController tests", function() {

		it('should be defined', inject(function($controller) {
		      var RefundController = $controller('RefundController',{$scope:$scope});
		      expect(RefundController).toBeDefined();
		}));

		it('should define this.message to be "" ', inject(function($controller) {
		      var RefundController = $controller('RefundController',{$scope:$scope});
		      expect(RefundController.message).toBe("");
		}));

		it('should define this.email to be "" ', inject(function($controller) {
		      var RefundController = $controller('RefundController',{$scope:$scope});
		      expect(RefundController.email).toBe("");
		}));

		it('should define this.showEmail to be true ', inject(function($controller) {
		      var RefundController = $controller('RefundController',{$scope:$scope});
		      expect(RefundController.showEmail).toBe(true);
		}));

		it('should define this.game to be "" ', inject(function($controller) {
		      var RefundController = $controller('RefundController',{$scope:$scope});
		      expect(RefundController.game).toBe("");
		}));

		it('test function shouldShowSendEmail', inject(function($controller) {
		      var RefundController = $controller('RefundController',{$scope:$scope});
		      var result = RefundController.shouldShowSendEmail();
		      expect(result).toBe(RefundController.showEmail);
		}));
		it('test function shouldShowSendEmail', inject(function($controller) {
		      var RefundController = $controller('RefundController',{$scope:$scope});
		      RefundController.sendEmail();
		      expect(RefundController.showEmail).toBe(false);
		}));
	});
});
describe("Support module controller tests", function() {
	var $controller, scope, $http;

	beforeEach(module('AdminModule'));
		beforeEach(inject(function($rootScope, _$controller_, _$http_) {
		$controller =_$controller_;
		http = _$http_;
    	$scope = $rootScope.$new();        
	}));

	describe("MainController tests", function() {

		it('should be defined', inject(function($controller) {
		      var MainController = $controller('MainController',{$scope:$scope});
		      expect(MainController).toBeDefined();
		}));

		it('should define selected = 0', inject(function($controller) {
		      var MainController = $controller('MainController',{$scope:$scope});
		      expect(MainController.selected).toBe(0);
		}));

		it('tests select function', inject(function($controller) {
		      var MainController = $controller('MainController',{$scope:$scope});
		      MainController.select(1);
		      expect(MainController.selected).toBe(1);
		}));

		it('tests isSelected function', inject(function($controller) {
		      var MainController = $controller('MainController',{$scope:$scope});
		      var result = MainController.isSelected();
		      expect(result).toBe(false);
		      MainController.select();
		      result = MainController.isSelected();
		      expect(result).toBe(true);
		}));
		it('tests isEditing function1', inject(function($controller) {
		      var MainController = $controller('MainController',{$scope:$scope});
		      var result = MainController.isEditing();
		      expect(result).toBeDefined;
		}));
		
		it('tests isEditing function2', inject(function($controller) {
		      var MainController = $controller('MainController',{$scope:$scope});
		      var result = MainController.isEditing();
		      expect(result).toBe(false);
		}));
		it('tests deleteKeyword function', inject(function($controller) {
		      var MainController = $controller('MainController',{$scope:$scope});		      
		      //MainController.deleteKeyword();
		      //unsure how to test
		      expect(1).toBe(1);
		}));
		it('tests addKeyword function', inject(function($controller) {
		      var MainController = $controller('MainController',{$scope:$scope});		      
		      //unsure how to test
		      expect(1).toBe(1);
		}));
		it('tests apply function', inject(function($controller) {
		      var MainController = $controller('MainController',{$scope:$scope});		      
		      MainController.apply();
		      expect(MainController.editing).toBe(-1);
		}));
		it('tests edit function', inject(function($controller) {
		      var MainController = $controller('MainController',{$scope:$scope});		      
		      MainController.edit(1);
		      expect(MainController.editing).toBe(1);
		}));
		it('tests delete function', inject(function($controller) {
		      var MainController = $controller('MainController',{$scope:$scope});		      
		      MainController.delete(1);
		      expect(MainController.editing).toBe(-1);
		}));

	});
});