package de.atns.common.gwt.client;

import com.google.web.bindery.event.shared.HandlerRegistration;

/**
 * @author tbaum
 * @since 06.10.2010
 */
public class ListHandlerRgistration implements HandlerRegistration {

    private final HandlerRegistration[] handlerRegistration;

    public static HandlerRegistration toList(final HandlerRegistration... handlerRegistration) {
        return new ListHandlerRgistration(handlerRegistration);
    }

    private ListHandlerRgistration(final HandlerRegistration... handlerRegistration) {
        this.handlerRegistration = handlerRegistration;
    }

    @Override public void removeHandler() {
        for (final HandlerRegistration registration : handlerRegistration) {
            try {
                registration.removeHandler();
            } catch (Exception ignored) {
            }
        }
    }
}
