define(function () {
// -----------------------------------------------------------------------------


/**
 * @constructor
 */
function Message(message) {
    this.message = message;
}


/**
 * Render the message onto the page.
 */
Message.prototype.show = function () {
	var p = document.createElement('p');
	var t = document.createTextNode(this.message);

	p.appendChild(t);

	document.body.appendChild(p);
}


return Message;


// -----------------------------------------------------------------------------
});
