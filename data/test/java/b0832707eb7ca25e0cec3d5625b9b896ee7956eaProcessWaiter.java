package com.dragonflow.erlangecc.monitor.weblogic;


public class ProcessWaiter extends Thread
{

    public ProcessWaiter(RMIProcessProperties p)
    {
        processProps = p;
        process = processProps.getProcess();
    }

    public ProcessWaiter(Process p)
    {
        processProps = null;
        process = p;
    }

    public void run()
    {
        for(boolean completed = false; !completed; completed = waitForProcess());
        if(process.exitValue() != 0)
           System.out.println("Exit code of RMI process was nonzero: " + process.exitValue());
        if(processProps != null)
            processProps.setRunning(false);
    }

    private boolean waitForProcess()
    {
        try
        {
            process.waitFor();
        }
        catch(InterruptedException e)
        {
            System.out.println("Caught InterruptedException while waiting for RMI Process, will wait again.");
            return false;
        }
        return true;
    }

   RMIProcessProperties processProps;
    Process process;

}