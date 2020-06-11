package composer.args ;

import java.io.File ;

/**
 * <code>Handlers</code> is a utility class with static factory methods to
 * return instances of argument {@link Handler} objects.
 **/
public final class Handlers {

    public static final BooleanHandler booleanHandler (boolean initialValue) {
	return new BooleanHandler (initialValue) ;
    }

    public static final BooleanHandler booleanHandler (Boolean initialValue) {
	return new BooleanHandler (initialValue) ;
    }

    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

    public static final CountHandler countHandler (int initialValue) {
	return new CountHandler (initialValue) ;
    }

    public static final CountHandler countHandler (Integer initialValue) {
	return new CountHandler (initialValue) ;
    }

    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

    public static final InputFileHandler inputFileHandler (File defaultFile) {
	return
	    defaultFile != null
	    ? new InputFileHandler (null, defaultFile)
	    : inputFileHandler () ;
    }

    public static final InputFileHandler inputFileHandler () {
	return InputFileHandler.NULL_HANDLER ;
    }

    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

    public static final OutputFileHandler outputFileHandler (File defaultOut) {
	return
	    defaultOut != null
	    ? new OutputFileHandler (null, defaultOut)
	    : outputFileHandler () ;
    }

    public static final OutputFileHandler outputFileHandler () {
	return OutputFileHandler.NULL_HANDLER ;
    }

    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

    final public static PatternHandler patternHandler (String defaultValue) {
	return
	    defaultValue != null
	    ? new PatternHandler (defaultValue)
	    : patternHandler () ;
    }

    public static final PatternHandler patternHandler () {
	return PatternHandler.NULL_HANDLER ;
    }

    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

    public static final StringHandler stringHandler (String defaultValue) {
	return
	    defaultValue != null
	    ? new StringHandler (defaultValue)
	    : stringHandler () ;
    }

    public static final StringHandler stringHandler () {
	return StringHandler.NULL_HANDLER ;
    }

    /* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

    /**
     * Private constructor to prevent external instantiation.
     **/
    private Handlers () {
	/* Empty body. */
    }

}
