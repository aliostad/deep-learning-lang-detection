goog.provide('jchemhub.controller.AtomController');
goog.require('goog.events.EventTarget');

/** 
 * @constructor 
 * @extends {goog.events.EventTarget} 
 */ 
jchemhub.controller.AtomController = function(parentController) { 
  goog.events.EventTarget.call(this);
  this.setParentEventTarget(parentController);
}; 
goog.inherits(jchemhub.controller.AtomController, goog.events.EventTarget); 

jchemhub.controller.AtomController.prototype.handleMouseOver = function(atom, e){
	this.dispatchEvent(jchemhub.controller.AtomController.EventType.MOUSEOVER);
};

jchemhub.controller.AtomController.prototype.handleMouseOut = function(atom, e){
	this.dispatchEvent(jchemhub.controller.AtomController.EventType.MOUSEOUT);
};
/** @enum {string} */ 
jchemhub.controller.AtomController.EventType = { 
  MOUSEOVER: 'atom_mouseover',
  MOUSEOUT: 'atom_mouseout'
}; 
