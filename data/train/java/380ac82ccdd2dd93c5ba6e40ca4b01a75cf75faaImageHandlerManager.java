package es.icarto.gvsig.navtableforms.gui.images;

import java.util.HashMap;
import java.util.Map;

public class ImageHandlerManager {
    
    private Map<String, ImageHandler> handlers = new HashMap<String, ImageHandler>();

    public void setListeners() {
	for (ImageHandler handler : handlers.values()) {
	    handler.setListeners();
	}
    }

    public void removeListeners() {
	for (ImageHandler handler : handlers.values()) {
	    handler.removeListeners();
	}
    }

    public void fillEmptyValues() {
	for (ImageHandler handler : handlers.values()) {
	    handler.fillEmptyValues();
	}
    }

    public void fillValues() {
	for (ImageHandler handler : handlers.values()) {
	    handler.fillValues();
	}
    }

    public void addHandler(ImageHandler handler) {
	handlers.put(handler.getName(), handler);
    }
    
    

}
