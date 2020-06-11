package rabbit.io;

/** A class to hold information about when an operation 
 *  was attached to the selector. Needed for timeout options.
 */
public class HandlerRegistration {
    public long when;
    public SocketHandler handler;

    public HandlerRegistration (SocketHandler handler) {
	this.when = System.currentTimeMillis ();
	this.handler = handler;
    }

    public HandlerRegistration (SocketHandler handler, long when) {
	this.when = when;
	this.handler = handler;
    }

    public String toString () {
	return "HandlerRegistration[when: " + when + 
	    ", handler: " + handler + "]";
    }
}
    
