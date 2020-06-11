package org.apache.juli;

import java.util.logging.LogRecord;

public class AsyncFileHandlerLogEntry {
    private LogRecord record;
    private AsyncFileHandler handler;
    public AsyncFileHandlerLogEntry(LogRecord record, AsyncFileHandler handler) {
        super();
        this.record = record;
        this.handler = handler;
    }
    
    public boolean flush() {
        if (handler.isClosed()) {
            return false;
        } else {
            handler.publishInternal(record);
            return true;
        }
    }
    
}