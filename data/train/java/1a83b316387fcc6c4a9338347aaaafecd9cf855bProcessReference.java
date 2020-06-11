/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package nava.tasks;

import java.util.ArrayList;

/**
 * This object is passed to a method. Allows processes registered with this object to be cancelled outside of the method.
 * 
 * @author Michael Golden <michaelgolden0@gmail.com>
 */
public class ProcessReference {
    
    ArrayList<ProcessObject> referencedProcesses = new ArrayList<>();
    public boolean cancelled = false;
    
    public void addProcess(Process process)
    {
        referencedProcesses.add(new ProcessObject(process));
    }    
    
    public boolean isAlive(Process process)
    {
        for(ProcessObject p : referencedProcesses)
        {
            if(p.process.equals(process))
            {
                return !p.cancelled;
            }
        }
        
        return true;
    }
    
    public void cancelAllProcesses()
    {
        for(ProcessObject p : referencedProcesses)
        {
            if(p.process != null)
            {
                p.process.destroy();
                p.cancelled = true;
            }
        }
        this.cancelled = true;
    }
}

class ProcessObject
{
    public Process process;
    public boolean cancelled = false;
    
    public ProcessObject(Process process)
    {
        this.process = process;
    }
}
