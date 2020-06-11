package net.paslavsky.gwt.gootstrap.client.base;

import com.google.gwt.dom.client.Document;
import com.google.gwt.dom.client.Element;
import com.google.gwt.event.dom.client.*;
import com.google.gwt.event.shared.HandlerRegistration;
import net.paslavsky.gwt.gootstrap.client.internal.MouseAdapter;
import net.paslavsky.gwt.gootstrap.client.internal.TouchAdapter;

/**
 * Label widget
 *
 * @author Andrey Paslavsky
 * @version 1.0
 */
public abstract class Label extends Widget implements MouseAdapter.MouseSupport, HasAllTouchHandlers {
    private final MouseAdapter mouseAdapter = new MouseAdapter(this);
    private final TouchAdapter touchAdapter = new TouchAdapter(this);
    private boolean hidden = false;

    protected Label() {
        super("");
    }

    @Override
    protected Element createElement(Object... args) {
        return Document.get().createLabelElement();
    }

    public boolean isHidden() {
        return hidden;
    }

    public void setHidden(boolean hidden) {
        this.hidden = hidden;
        applyStyle();
    }

    @Override
    protected void applyStyle() {
        super.applyStyle();
        if (hidden) {
            addStyleName("sr-only");
        }
    }

    public String getFor() {
        return getElement().getAttribute("for");
    }

    public void setFor(String forValue) {
        getElement().setAttribute("for", forValue);
    }

    //region MouseAdapter.MouseSupport
    @Override
    public HandlerRegistration addMouseDownHandler(MouseDownHandler handler) {
        return mouseAdapter.addMouseDownHandler(handler);
    }

    @Override
    public HandlerRegistration addMouseMoveHandler(MouseMoveHandler handler) {
        return mouseAdapter.addMouseMoveHandler(handler);
    }

    @Override
    public HandlerRegistration addMouseOutHandler(MouseOutHandler handler) {
        return mouseAdapter.addMouseOutHandler(handler);
    }

    @Override
    public HandlerRegistration addMouseOverHandler(MouseOverHandler handler) {
        return mouseAdapter.addMouseOverHandler(handler);
    }

    @Override
    public HandlerRegistration addMouseUpHandler(MouseUpHandler handler) {
        return mouseAdapter.addMouseUpHandler(handler);
    }

    @Override
    public HandlerRegistration addMouseWheelHandler(MouseWheelHandler handler) {
        return mouseAdapter.addMouseWheelHandler(handler);
    }

    @Override
    public HandlerRegistration addClickHandler(ClickHandler handler) {
        return mouseAdapter.addClickHandler(handler);
    }

    @Override
    public HandlerRegistration addDoubleClickHandler(DoubleClickHandler handler) {
        return mouseAdapter.addDoubleClickHandler(handler);
    }

    @Override
    public HandlerRegistration addContextMenuHandler(ContextMenuHandler handler) {
        return mouseAdapter.addContextMenuHandler(handler);
    }
    //endregion

    //region HasAllTouchHandlers
    @Override
    public HandlerRegistration addTouchCancelHandler(TouchCancelHandler handler) {
        return touchAdapter.addTouchCancelHandler(handler);
    }

    @Override
    public HandlerRegistration addTouchEndHandler(TouchEndHandler handler) {
        return touchAdapter.addTouchEndHandler(handler);
    }

    @Override
    public HandlerRegistration addTouchMoveHandler(TouchMoveHandler handler) {
        return touchAdapter.addTouchMoveHandler(handler);
    }

    @Override
    public HandlerRegistration addTouchStartHandler(TouchStartHandler handler) {
        return touchAdapter.addTouchStartHandler(handler);
    }
    //endregion
}
