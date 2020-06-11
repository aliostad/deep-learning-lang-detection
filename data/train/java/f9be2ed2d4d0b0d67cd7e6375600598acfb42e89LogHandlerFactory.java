package br.ufpb.dicomflow.integrationAPI.log;

import java.util.ArrayList;
import java.util.List;

public class LogHandlerFactory {
    
    public static final String DB_HANDLER = "db";
    public static final String FILE_HANDLER = "file";
    public static final String CONSOLE_HANDLER = "console";
    
    public static LogHandler createLogHandler(String type){
        if(type != null){
            if (type.equals(DB_HANDLER)) {
                return createDBHandler();
            } else if(type.equals(FILE_HANDLER)){
                return createFileHandler();
            } else if(type.equals(CONSOLE_HANDLER)){
                return createConsoleHandler();
            }
        }
        
        return null;
    }
    
    public static List<LogHandler> createLogHandler(List<String> types){
        
        List<LogHandler> handlers = new ArrayList<LogHandler>();
        
        if(types != null && !types.isEmpty()){
            for (String type : types) {
                LogHandler handler = createLogHandler(type);
                
                if(handler != null){
                    handlers.add(handler);
                }
            }
        }
        
        
        return handlers;
    }
    
    public static LogHandler createDBHandler(){
        return new DBHandler();
    }
    
    public static LogHandler createFileHandler(){
        return new FileHandler();
    }
    
    public static LogHandler createConsoleHandler(){
        return new ConsoleHandler();
    }
    
}
