/**
 *
 */
goog.require('SB.Service');
goog.provide('SB.EventService');

/**
 * The EventService.
 *
 * @extends {SB.Service}
 */
SB.EventService = function() {};

goog.inherits(SB.EventService, SB.Service);

//---------------------------------------------------------------------
// Initialization/Termination
//---------------------------------------------------------------------

/**
 * Initializes the events system.
 */
SB.EventService.prototype.initialize = function(param) {};

/**
 * Terminates the events world.
 */
SB.EventService.prototype.terminate = function() {};


/**
 * Updates the EventService.
 */
SB.EventService.prototype.update = function()
{
	do
	{
		SB.EventService.eventsPending = false;
		SB.Game.instance.updateEntities();
	}
	while (SB.EventService.eventsPending);
}