/**********************************************************************
 *
 * show/obj.js
 *
 * author: Patrick Dooley
 *
 *
 **********************************************************************/

define
(
	[
		"../link/obj"
	],
	function
	(
		link
	)
	{

	//*******************************************************************//
	//***																	   
	//***		public initializors
	//***
	//*******************************************************************//

		function show()
		{
			//console.log("show::constructor")

			this.m_sKWExt			= "show";
		}

		show.prototype = new link();
		show.prototype.constructor = show;
		show.constructor = link.prototype.constructor;
		
		show.prototype.check = function check()
		{
			link.prototype.check.call(this);
			//console.log(this.kWLogCalled());
		};

		show.prototype.init = function init()
		{
			//console.log(this.kWLogCalled())
			link.prototype.init.call(this);
		};

	//*******************************************************************//
	//***																	   
	//***		public accessors
	//***
	//*******************************************************************//

	//*******************************************************************//
	//***																	   
	//***		public callbacks
	//***
	//*******************************************************************//

	//*******************************************************************//
	//***																	   
	//***		public methods
	//***
	//*******************************************************************//

	//*******************************************************************//
	//***																	   
	//***		private methods (non-ovrrides)
	//***
	//*******************************************************************//
		
		show.prototype.linkInitImpl = function()
		{
			this.showInit();
		};

	//*******************************************************************//
	//***																	   
	//***		private methods
	//***
	//*******************************************************************//

		show.prototype.showInit = 
			function showInit()
		{
			//console.log(this.kWLogCalled())
		};

		return show;
		
	}
)