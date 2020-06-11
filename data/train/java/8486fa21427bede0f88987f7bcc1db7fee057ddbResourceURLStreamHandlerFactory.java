package uk.ac.imperial.doc.mfldb.util;

import java.net.URLStreamHandler;
import java.net.URLStreamHandlerFactory;

import static uk.ac.imperial.doc.mfldb.util.Const.*;

/**
 * Implementation of {@link URLStreamHandlerFactory} for constructing {@link ResourceURLStreamHandler}s.
 */
public class ResourceURLStreamHandlerFactory implements URLStreamHandlerFactory {

    /**
     * URLStreamHandler instance for CodeMirror files.
     */
    private final URLStreamHandler codeMirrorHandler;

    /**
     * URLStreamHandler instance for RequireJS files.
     */
    private final URLStreamHandler requireJSHandler;

    /**
     * URLStreamHandler instance for D3.js files.
     */
    private final URLStreamHandler d3jsHandler;

    /**
     * URLStreamHandler instance for jQuery files.
     */
    private final URLStreamHandler jQueryHandler;

    /**
     * URLStreamHandler instance for jsPlumb files.
     */
    private final URLStreamHandler jsPlumbHandler;

    /**
     * Injection constructor to be used by tests.
     *
     * @param codeMirrorHandler
     */
    protected ResourceURLStreamHandlerFactory(URLStreamHandler codeMirrorHandler, URLStreamHandler requireJSHandler, URLStreamHandler d3jsHandler, URLStreamHandler jQueryHandler, URLStreamHandler jsPlumbHandler) {
        this.codeMirrorHandler = codeMirrorHandler;
        this.requireJSHandler = requireJSHandler;
        this.d3jsHandler = d3jsHandler;
        this.jQueryHandler = jQueryHandler;
        this.jsPlumbHandler = jsPlumbHandler;
    }

    /**
     * Constructs a new ResourceURLStreamHandlerFactory instance.
     */
    public ResourceURLStreamHandlerFactory() {
        this(
                new ResourceURLStreamHandler(CODE_MIRROR_BASEPATH),
                new ResourceURLStreamHandler(REQUIRE_JS_BASEPATH),
                new ResourceURLStreamHandler(D3_JS_BASEPATH),
                new ResourceURLStreamHandler(JQUERY_BASEPATH),
                new ResourceURLStreamHandler(JS_PLUMB_BASEPATH)
        );
    }

    @Override
    public URLStreamHandler createURLStreamHandler(String protocol) {
        if (protocol.equals(CODE_MIRROR_PROTOCOL)) {
            return codeMirrorHandler;
        } else if (protocol.equals(REQUIRE_JS_PROTOCOL)) {
            return requireJSHandler;
        } else if (protocol.equals(D3_JS_PROTOCOL)) {
            return d3jsHandler;
        } else if (protocol.equals(JQUERY_PROTOCOL)) {
            return jQueryHandler;
        } else if (protocol.equals(JS_PLUMB_PROTOCOL)) {
            return jsPlumbHandler;
        } else {
            return null;
        }
    }
}
