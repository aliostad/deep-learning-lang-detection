/*
 * Team : AGF AM / OSI / SI / BO
 *
 * Copyright (c) 2001 AGF Asset Management.
 */
package net.codjo.mad.server.handler;
import net.codjo.mad.common.Log;
import org.picocontainer.MutablePicoContainer;
/**
 * Implementation par défaut d'un {@link HandlerMap}.
 *
 * <p> Stock les handler sous forme d'instance. </p>
 */
public class DefaultHandlerMap extends HandlerMapImpl {
    public DefaultHandlerMap() {
    }


    public DefaultHandlerMap(MutablePicoContainer parentContainer) {
        super(parentContainer);
    }


    public void addHandler(Handler handler) {
        handlerContainer.registerComponentInstance(handler.getId(), handler);
    }


    @Override
    public Handler getHandler(String handlerId) {
        Handler handler = super.getHandler(handlerId);

        if (handler != null && !handlerId.equals(handler.getId())) {
            Log.error("Pb dans la recuperation du handler :"
                      + " Incohérence detecte entre l'id demande et l'id du handler "
                      + "(id_demande = " + handlerId + " / id_handler=" + handler.getId()
                      + " / handler_class=" + handler.getClass() + " )");
            return null;
        }

        return handler;
    }


    MutablePicoContainer getPicoContainer() {
        return handlerContainer;
    }
}
