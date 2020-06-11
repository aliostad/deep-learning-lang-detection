import java.lang.*;
import java.util.ArrayList;
import java.util.List;

/**
 * Created by indenml on 21.06.15.
 */
public class HighestResponseRatioNext extends SchedulingAlgorithm{


    public HighestResponseRatioNext(List<Process> inputProcesses){
        super(inputProcesses);
    }


    public  Schedule generateProcessSchedule() {

        /* ---------------------- Algorithm ----------------------*/
        while(!processes.isEmpty()) {

            //Check if the currently running process is done
            if(currentlyRunningProcess != null){
                if(currentlyRunningProcess.getProcessingTime() == ct-startTimeCuRuPr){
                    schedule.add(new ScheduleItem(currentlyRunningProcess.getProcessID(), startTimeCuRuPr, ct, true));
                    processes.remove(currentlyRunningProcess);
                    currentlyRunningProcess = null;
                    startTimeCuRuPr = null;
                }
            }

            //Check if the currently running Process is blocked
            if(currentlyRunningProcess != null){
                if(currentlyRunningProcess.isBlocked(ct)){
                    schedule.add(new ScheduleItem(currentlyRunningProcess.getProcessID(), startTimeCuRuPr, ct, false));
                    currentlyRunningProcess.setProcessingTime(currentlyRunningProcess.getProcessingTime() - ( ct-startTimeCuRuPr));
                    currentlyRunningProcess = null;
                    startTimeCuRuPr = null;
                }
            }

            //Fill the processQue
            fillProcessQue();

            //If there are no processes currently ready
            if (processQueue.isEmpty()){
                ct++;
                continue;
            }

            if(currentlyRunningProcess != null){
                ct++;
                continue;
            }

            //Find process with highest response ratio
            Process interestingProcess = getProcessHighestResponseRatio();

            //run that process
            runProcess(interestingProcess);

        }

        return schedule;
    }



    public  Process getProcessHighestResponseRatio(){
        Process interestingProcess = processQueue.get(0);
        Float highestResponseRatio = getResponseRatio(ct, interestingProcess);
        for(Process process : processQueue){
            if (getResponseRatio(ct, process) > highestResponseRatio){
                interestingProcess = process;
                highestResponseRatio = getResponseRatio(ct, process);
            }
        }
        return interestingProcess;
    }

    public  Float getResponseRatio(Integer currentTime, Process process){
        return (Float.valueOf((currentTime - process.getArrivalTime()) + process.getProcessingTime()) / Float.valueOf(process.getProcessingTime()));
    }


}
