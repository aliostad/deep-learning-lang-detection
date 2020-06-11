package org.turbodi.mimedecoder.handler;

import org.turbodi.mimedecoder.handler.*;

import java.util.HashMap;
import java.util.Map;

/**
* @author borisov
* @since 20.12.2012
*/
public class MultipartHandlerRegistry
{
    private static final Map<String, IMultipartHandler> SUBTYPE_TO_HANDLER = new HashMap<String, IMultipartHandler>();

    static
    {
        SUBTYPE_TO_HANDLER.put(MultipartMixedHandler.TYPE, new MultipartMixedHandler());
        SUBTYPE_TO_HANDLER.put(MultipartAlternativeHandler.TYPE, new MultipartAlternativeHandler());
        SUBTYPE_TO_HANDLER.put(MultipartRelatedHandler.TYPE, new MultipartRelatedHandler());
        SUBTYPE_TO_HANDLER.put(MultipartDigestHandler.TYPE, new MultipartDigestHandler());
    }
    
    public static IMultipartHandler getMultipartHandlerByType(String type)
    {
        IMultipartHandler handler = SUBTYPE_TO_HANDLER.get(type);
        //Any "multipart" subtypes that an implementation does not recognize must be treated as being of subtype "mixed".
        return handler != null ? handler : new MultipartMixedHandler();
    }
}
