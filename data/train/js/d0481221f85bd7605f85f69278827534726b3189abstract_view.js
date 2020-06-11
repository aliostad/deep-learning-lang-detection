function AbstractView() {
	this.controller = null;
}

AbstractView.prototype.setController = function(controller) {
	this.controller = controller;
};

/**
 * @returns {AbstractController}
 */
AbstractView.prototype.getController = function() {
	return this.controller;
};


/**
 * Draws view, called at render
 * 
 * @param {AbstractController}
 *            controller
 */
AbstractView.prototype.draw = function(controller) {
	this.setController(controller);
};

/**
 * Called before draw
 */
AbstractView.prototype.before = function() {
	// Void
};

/**
 * Called after draw
 */
AbstractView.prototype.after = function() {
	// Void
};