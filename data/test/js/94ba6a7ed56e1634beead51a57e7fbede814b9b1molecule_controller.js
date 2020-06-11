goog.provide('jchemhub.controller.MoleculeController');
goog.require('goog.events.EventTarget');

/** 
 * @constructor 
 * @extends {goog.events.EventTarget} 
 */ 
jchemhub.controller.MoleculeController = function(parentController) { 
  goog.events.EventTarget.call(this);
  this.setParentEventTarget(parentController);

}; 
goog.inherits(jchemhub.controller.MoleculeController, goog.events.EventTarget); 

jchemhub.controller.MoleculeController.prototype.handleMouseOver = function(Molecule, e){
	console.log(Molecule.symbol);
	this.dispatchEvent(jchemhub.controller.MoleculeController.EventType.MOUSEOVER);
};

jchemhub.controller.MoleculeController.prototype.handleMouseOut = function(Molecule, e){
	this.dispatchEvent(jchemhub.controller.MoleculeController.EventType.MOUSEOUT);
};
/** @enum {string} */ 
jchemhub.controller.MoleculeController.EventType = { 
  MOUSEOVER: 'molecule_mouseover',
  MOUSEOUT: 'molecule_mouseout'
}; 
