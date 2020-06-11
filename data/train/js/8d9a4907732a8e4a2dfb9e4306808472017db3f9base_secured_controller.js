/**
 * @license Copyright (c) 2012, Viet Trinh All Rights Reserved.
 * Available via MIT license.
 */

/**
 * A abstract controller implementation which allows you to register secure routes.
 */
define([ 'framework/controller/base_controller', 
		 './i_secured_controller',
		 'framework/core/utils/clazz' ], 
function(BaseController, 
		 ISecuredController, 
		 ClazzUtils)
{
	var BaseSecuredController = function()
		{
			BaseController.call(this);
			
			return this;
		}

	BaseSecuredController.prototype = new BaseController();
	ClazzUtils.generateProperties(BaseSecuredController);
	ClazzUtils.inheritProperties(BaseSecuredController, ISecuredController);

	return BaseSecuredController;
});