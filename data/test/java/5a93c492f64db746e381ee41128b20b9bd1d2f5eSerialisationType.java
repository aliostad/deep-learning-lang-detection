package tk.manf.serialisation;

import tk.manf.serialisation.handler.SerialisationHandler;

/**
 * Serialisation Types for Unit
 * 
 * @author Björn 'manf' Heinrichs
 */
public enum SerialisationType {
    /**
     * Serialisation for YAML Files
     */
    FLATFILE_YAML();

    /**
     * Loading of SerialisationType
     */
    private SerialisationType() {
    }

    /**
     * Gets current Handler for Serialisation Type
     * @return Serialisation Type
     */
    public SerialisationHandler getHandler() {
        return handler;
    }
    
    /**
     * Sets new Serialisation Handler for Handling
     * Possible to add any custome Handler by other Plugins
     * @param handler handler
     */
    public void setSerialisationHandler(SerialisationHandler handler) {
        this.handler = handler;
    }  
    
    /**
     * Handler for Serialisation
     */
    private SerialisationHandler handler;
}
