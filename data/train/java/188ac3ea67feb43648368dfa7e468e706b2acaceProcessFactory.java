/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package process;

import exceptions.NoSuchTypeOfProcessException;
import java.util.HashMap;
import org.w3c.dom.Element;

/**
 * Factoria de creación de Procesos. Es Singleton
 * @author javier.abella
 */
public class ProcessFactory {
    
    private static ProcessFactory instance;
    
    private ProcessFactory(){
        
    }
    
    public static ProcessFactory getInstance(){
        if (instance == null){
            synchronized(ProcessFactory.class){
                if (instance == null){
                    instance = new ProcessFactory();
                }
            }            
        }

        return instance;
    }
    
    private HashMap processMap = new HashMap();
    
    public void registerProcess (int processID, ProcessType process){
        processMap.put(processID, process);
    }
    

    
    public ProcessType createProcess(int tipo, Element elementProcess) throws NoSuchTypeOfProcessException{
        if(processMap.get(tipo)==null){
            throw new NoSuchTypeOfProcessException();
        }
        ProcessType productClass = (ProcessType)processMap.get(tipo);
        return productClass.createProcess(elementProcess);
    }
    
}
