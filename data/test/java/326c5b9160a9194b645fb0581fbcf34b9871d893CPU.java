package computer;
import Processes.Process;
import app.OSGUI;
/**
 *
 * @author Malith
 */
public class CPU {
      private Process runningProcess;
      OSGUI gui;

    public OSGUI getGui() {
        return gui;
    }
      
    public CPU(OSGUI gui) {
       this.gui = gui;
    }

    public CPU() {
    }

    public Process getRunningProcess() {
        return runningProcess;
    }

    public void dispatch(Process process) {
        this.runningProcess = process;
    }
    
    public void execute(int nextCPUtime, Process process){
        runningProcess.runProcess(nextCPUtime);
        
        
        
        gui.display(process.getName(), (int) nextCPUtime, process.getArrivalTime(),process.getServiceTime(),process.getRemainingServiceTime());
        //System.out.println(process.getName() + "*************************"+ (int)nextCPUtime);
        
    }
    public Process preempt(){
        return runningProcess;
    }
    public Process block(){
        return runningProcess;
    }
      
}
