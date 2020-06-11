package compiler;

/** Base class for compiler phases.  Its only real purpose is to provide
 *  convenient access to a diagnostic handler.
 */
public abstract class Phase {
    private Handler handler;

    /** Construct a new phase with a specified diagnostic handler.
     */
    protected Phase(Handler handler) {
        this.handler = handler;
    }

    /** Return the handler for this phase.
     */
    public Handler getHandler() {
        return handler;
    }

    /** Report a diagnostic detected in this phase.
     */
    public void report(Diagnostic d) {
        if (handler!=null) {
            handler.report(d);
        }
    }
}
