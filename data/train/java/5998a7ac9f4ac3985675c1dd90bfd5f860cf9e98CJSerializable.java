package com.ehudblum.creeperjobs.config;

public abstract class CJSerializable {
    private DataHandler<?> dataHandler;
    
    public CJSerializable(DataHandler<?> dataHandler) {
        this.dataHandler = dataHandler;
    }

    /**
     * @return the dataHandler
     */
    public DataHandler<?> getDataHandler() {
        return dataHandler;
    }

    /**
     * @param dataHandler the dataHandler to set
     */
    public void setDataHandler(DataHandler<?> dataHandler) {
        this.dataHandler = dataHandler;
    }
    
    
}
