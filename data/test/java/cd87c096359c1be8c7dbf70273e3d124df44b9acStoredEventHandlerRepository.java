package org.yellowbinary.server.backend.event.handler;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.yellowbinary.server.backend.dao.event.EventHandlerDao;
import org.yellowbinary.server.backend.model.event.StoredEventHandler;
import org.yellowbinary.server.core.event.handler.EventHandler;
import org.yellowbinary.server.core.event.handler.EventHandlerRepository;

@Repository
public class StoredEventHandlerRepository implements EventHandlerRepository {

    @Autowired
    private EventHandlerDao eventHandlerDao;

    @Override
    public EventHandler getEventHandler(String base, String with) {
        return eventHandlerDao.findWithBaseAndWithType(base, with);
    }

    @Override
    public void storeEventHandler(String base, String with, String annotation, String handlerClass) {
        StoredEventHandler eventHandler = new StoredEventHandler();
        eventHandler.setBaseType(base);
        eventHandler.setWithType(with);
        eventHandler.setAnnotation(annotation);
        eventHandler.setHandlerClass(handlerClass);
        eventHandlerDao.save(eventHandler);
    }
}
