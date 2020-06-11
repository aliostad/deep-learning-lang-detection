/**
 * 
 */
package org.ubimix.scraper.protocol;

/**
 * @author kotelnikov
 */
public class ProtocolHandlerUtils {

    public static void registerDefaultProtocols(CompositeProtocolHandler handler) {
        HttpProtocolHandler httpProtocolHandler = new HttpProtocolHandler();
        handler.setProtocolHandler("http", httpProtocolHandler);
        handler.setProtocolHandler("https", httpProtocolHandler);
        handler.setProtocolHandler("file", new FileProtocolHandler());
        handler.setProtocolHandler("classpath", new ClasspathProtocolHandler());
        IProtocolHandler urlBasedHandler = new UrlBasedProtocolHandler();
        handler.setDefaultProtocolHandler(urlBasedHandler);
    }

}
