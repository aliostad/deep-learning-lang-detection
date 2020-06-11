/**********************************************************************
 *
 * nav/obj.js
 *
 * author: Patrick Dooley
 *
 *
 **********************************************************************
 *
 * Copyright (c) 2013 iTKunst Corporation
 *
 **********************************************************************/

define
(
	[	
		"../../attrs/simple/obj",
		"../../view/simple/obj",
		"../../../base/elmt/obj",
		"kWStat/validate"
	], 
	function
	(
		attrs,
		view,
		elmt,
		validate
	)
	{
			
	//*******************************************************************//
	//***																	   
	//***		pubnavc initianavzors
	//***
	//*******************************************************************//

		function nav()
		{
			//console.log("nav::constructor");
			this.m_sKWTag	= "nav";
		}

		nav.prototype = new elmt();
		nav.prototype.constructor = nav;
		nav.constructor = elmt.prototype.constructor;

		nav.prototype.check = 
			function check()
		{
			elmt.prototype.check.call(this);
			//console.log(this.kWLogCalled());
		};

		nav.prototype.init =
			function init()
		{
			//console.log(this.kWLogCalled());
			elmt.prototype.init.call(this);
		};

	//*******************************************************************//
	//***																	   
	//***		pubnavc accessors
	//***
	//*******************************************************************//

	//*******************************************************************//
	//***																	   
	//***		pubnavc callbacks
	//***
	//*******************************************************************//
	
	//*******************************************************************//
	//***																	   
	//***		pubnavc methods
	//***
	//*******************************************************************//

	//*******************************************************************//
	//***																	   
	//***		private methods (non-overrides)
	//***
	//*******************************************************************//
	
		nav.prototype.elmtCreateAttrsOR = 
			function()
		{
			return this.navCreateAttrs(); 
		};
		
		nav.prototype.elmtCreateViewOR = 
			function()
		{
			return this.navCreateView();
		};
		
		nav.prototype.elmtInitOR = 
			function()
		{
			this.navInit();
		};
		
		nav.prototype.elmtRetrieveOR = 
			function()
		{
			this.navRetrieve();
		};
		
	//*******************************************************************//
	//***																	   
	//***		private methods (overrides)
	//***
	//*******************************************************************//

		nav.prototype.navInitOR = 
			function navInitOR()
		{
			console.error(this.kWLogNotImpl());
		};
		
	//*******************************************************************//
	//***																	   
	//***		private methods
	//***
	//*******************************************************************//

		nav.prototype.navCreateAttrs = 
			function navCreateAttrs()
		{
			//console.log(this.kWLogCalled());
			return new attrs();
		};

		nav.prototype.navCreateView = 
			function navCreateView()
		{
			//console.log(this.kWLogCalled());
			return new view();
		};

		nav.prototype.navInit = 
			function navInit()
		{
			//console.log(this.kWLogCalled());
			this.navInitOR();
		};

		nav.prototype.navRetrieve = 
			function navRetrieve()
		{
			//console.log(this.kWLogCalled());
		};
		
		return nav;

	}
);
