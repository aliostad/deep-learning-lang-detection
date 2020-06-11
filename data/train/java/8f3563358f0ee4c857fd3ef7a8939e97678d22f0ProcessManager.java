/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package linksmatchmanager;

/**
 *
 * @author oaz
 */
public class ProcessManager
{
    boolean debug = true;
    int processCount;
    int max;

    /**
     * 
     * @param max 
     */
    public ProcessManager( int max )
    {
        processCount = 0;
        this.max = max;
    }
    
    /**
     * 
     * @return 
     */
    public boolean allowProcess()
    {
        if( debug ) { System.out.println( "allowProcess() processCount: " + processCount ); }
        if( processCount < max) { return true; }
        return false;
    }
    
    /**
     * 
     * @return 
     */
    public int addProcess()
    {
        if( debug ) { System.out.println( "addProcess() before: processCount: " + processCount ); }
        processCount++;
        if( debug ) { System.out.println( "addProcess() after: processCount: " + processCount ); }
        return processCount;
    }

    /**
     * 
     * @return 
     */
    public int removeProcess()
    {
        if( debug ) { System.out.println( "removeProcess() before: processCount: " + processCount ); }
        processCount--;
        if( debug ) { System.out.println( "removeProcess() after: processCount: " + processCount ); }
        return processCount;
    }

    /**
     * 
     * @return 
     */
    public int getProcessCount() {
        return processCount;
    }
}