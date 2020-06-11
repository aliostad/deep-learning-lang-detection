goog.provide('jchemhub.controller.AtomController');
goog.provide('jchemhub.controller.AtomController.AtomEvent');
goog.require('goog.events.EventTarget');
goog.require('goog.debug.Logger');

/**
 * @constructor
 * @extends {goog.events.EventTarget}
 */
jchemhub.controller.AtomController = function(parentController) {
	goog.events.EventTarget.call(this);
	this.setParentEventTarget(parentController);
};
goog.inherits(jchemhub.controller.AtomController, goog.events.EventTarget);

/**
 * Logging object.
 * 
 * @type {goog.debug.Logger}
 * @protected
 */
jchemhub.controller.AtomController.prototype.logger = goog.debug.Logger
		.getLogger('jchemhub.controller.AtomController');

jchemhub.controller.AtomController.prototype.handleMouseOver = function(atom, e) {
	this.dispatchEvent(new jchemhub.controller.AtomController.AtomEvent(this,
			atom, jchemhub.controller.AtomController.EventType.MOUSEOVER));
};

jchemhub.controller.AtomController.prototype.handleMouseOut = function(atom, e) {
	this.dispatchEvent(new jchemhub.controller.AtomController.AtomEvent(this,
			atom, jchemhub.controller.AtomController.EventType.MOUSEOUT));
};

jchemhub.controller.AtomController.prototype.handleMouseDown = function(atom, e) {
	this.dispatchEvent(new jchemhub.controller.AtomController.AtomEvent(this,
			atom, jchemhub.controller.AtomController.EventType.MOUSEDOWN));
};
/** @enum {string} */
jchemhub.controller.AtomController.EventType = {
	MOUSEOVER : 'atom_mouseover',
	MOUSEOUT : 'atom_mouseout',
	MOUSEDOWN : 'atom_mousedown'
};
/**
 * 
 * @param {jchemhub.controller.AtomController}
 *            controller
 * @param {jchemhub.model.Atom}
 *            atom
 * @param {jchemhub.controller.AtomController.EventType}
 *            type
 * @constructor
 * @extends {goog.events.Event}
 */
jchemhub.controller.AtomController.AtomEvent = function(controller, atom, type) {
	goog.events.Event.call(this, type, controller);
	this.atom = atom;
};
goog.inherits(jchemhub.controller.AtomController.AtomEvent, goog.events.Event);