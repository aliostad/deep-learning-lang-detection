package arriba.common;

import java.util.Map;

public final class MapHandlerRepository<ID, M> implements HandlerRepository<ID, M> {

    private final Map<ID, Handler<M>> messageIdentifierToHandler;
    
    public MapHandlerRepository(Map<ID, Handler<M>> messageIdentifierToHandler) {
        this.messageIdentifierToHandler = messageIdentifierToHandler;
    }
    
    public void registerHandler(ID messageIdentifier, Handler<M> handler) {
        messageIdentifierToHandler.put(messageIdentifier, handler);
    }

    public Handler<M> findHandler(ID messageIdentifier) throws NonexistentHandlerException {
        Handler<M> handler = messageIdentifierToHandler.get(messageIdentifier);
        if (null == handler) {
            throw new NonexistentHandlerException("Provided identifier " + messageIdentifier + 
                    " does not map to a known handler.");
        }
        
        return handler;
    }
}
