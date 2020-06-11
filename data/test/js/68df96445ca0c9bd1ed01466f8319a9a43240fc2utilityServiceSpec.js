describe('UtilityService', function() {
	var service = null;

	beforeEach(function() {
		service = EvaluateIt.utils.UtilityService;
	});
	
	it('service exists', function() {
		console.log('service::' + service);
		expect(service).toBeDefined();
	});

	it('translate evaluation rating to code', function() {
		expect(service.evaluation_rating(20)).toEqual('EG');
		expect(service.evaluation_rating(14)).toEqual('GD');
		expect(service.evaluation_rating(9)).toEqual('GM');
		expect(service.evaluation_rating(5)).toEqual('CA');
		expect(service.evaluation_rating(1)).toEqual('');
	});
	
});