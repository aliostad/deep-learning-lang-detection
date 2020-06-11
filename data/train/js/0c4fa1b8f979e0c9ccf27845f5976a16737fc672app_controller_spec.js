describe("App Controller", function(){
   beforeEach(function(){ 
   	appController = new App.Controller();
   });

	it("should be defined", function(){
		expect(appController).toBeDefined();
	}),

	it("has function 'loadNewStudio' ", function(){
		expect(appController.loadNewStudio).toBeDefined();
	}),

	it("has function 'loadStudioCollection' ", function(){
		expect(appController.loadStudioCollection).toBeDefined();
	}),

	it("has function 'registerStudioCollectionController' ", function(){
		expect(appController.registerStudioCollectionController).toBeDefined();
	}),

	it("has function 'registerStudioController' ", function(){
		expect(appController.registerStudioController).toBeDefined();
	}),

	it("has function 'registerSearchController' ", function(){
		expect(appController.registerSearchController).toBeDefined();
	}),

	it("initializes with an empty 'this.studioCollectionController' ", function(){
		expect(appController.studioCollectionController).toEqual({});
	}),

	it("initializes with an empty 'this.studioController' ", function(){
		expect(appController.studioController).toEqual({});
	}),

	it("initializes with an empty 'this.searchController' ", function(){
		expect(appController.searchController).toEqual({});
	}),

	it("sets the proper 'controller' key when calling 'registerStudioCollectionController' ", function(){
		appController.registerStudioCollectionController("controller", "method")
		expect(appController.studioCollectionController.controller).toEqual("controller");
	}),

	it("sets the proper 'callbackMethod' key when calling 'registerStudioCollectionController' ", function(){
		appController.registerStudioCollectionController("controller", "method")
		expect(appController.studioCollectionController.callbackMethod).toEqual("method");
	}),

	it("sets the proper 'controller' key when calling 'registerStudioController' ", function(){
		appController.registerStudioController("controller", "method")
		expect(appController.studioController.controller).toEqual("controller");
	}),

	it("sets the proper 'callbackMethod' key when calling 'registerStudioController' ", function(){
		appController.registerStudioController("controller", "method")
		expect(appController.studioController.callbackMethod).toEqual("method");
	}),

	it("sets the proper 'controller' key when calling 'registerSearchController' ", function(){
		appController.registerSearchController("controller", "method")
		expect(appController.searchController.controller).toEqual("controller");
	}),

	it("sets the proper 'callbackMethod' key when calling 'registerSearchController' ", function(){
		appController.registerSearchController("controller", "method")
		expect(appController.searchController.callbackMethod).toEqual("method");
	}),

	it("calls 'loadNewStudio' ", function(){
		testStudio = jasmine.createSpyObj('testStudio', ['update']);
		testSearch = jasmine.createSpyObj('testSearch', ['update']);
		appController.registerStudioController(testStudio, 'update')
		appController.registerSearchController(testSearch, 'update')
		appController.loadNewStudio()
		expect(testStudio.update).toHaveBeenCalled();
		expect(testSearch.update).toHaveBeenCalled();
	}),

	it("calls 'loadStudioCollection' ", function(){	
		subscriber = jasmine.createSpyObj('subscriber', ['update']);
		appController.registerStudioCollectionController(subscriber, 'update')	
		appController.loadStudioCollection()
		expect(subscriber.update).toHaveBeenCalled();
	})

});









