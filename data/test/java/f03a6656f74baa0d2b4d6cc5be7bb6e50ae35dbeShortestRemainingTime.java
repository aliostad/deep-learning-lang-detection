import java.util.ArrayList;
import java.util.List;

/**
 * Created by indenml on 21.06.15.
 */
public class ShortestRemainingTime extends SchedulingAlgorithm{

    public ShortestRemainingTime(List<Process> inputProcesses){
        super(inputProcesses);

    }

    public  Schedule generateProcessSchedule() {

        while(!processes.isEmpty()){

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
                    currentlyRunningProcess.setProcessingTime(currentlyRunningProcess.getProcessingTime() - (ct - startTimeCuRuPr));
                    currentlyRunningProcess = null;
                    startTimeCuRuPr = null;
                }
            }

            fillProcessQue();

            //If there are no processes currently ready
            if (processQueue.isEmpty()){
                ct++;
                continue;
            }

            //Get the process with the smallest processing time
            Process favouriteProcess = getProcessSmallestProcessingTime();

            if(currentlyRunningProcess != null) {

                //If favoriteProcess is the runningProcess
                if (currentlyRunningProcess.equals(favouriteProcess)) {
                    ct++;
                    continue;
                }

                //If currently running process is still faster than favouriteProcess
                if (currentlyRunningProcess.getProcessingTime() - (ct - startTimeCuRuPr) <= favouriteProcess.getProcessingTime()) {
                    ct++;
                    continue;
                }

                //If currently running process is slower then run favouriteProcess
                if (currentlyRunningProcess.getProcessingTime() - (ct - startTimeCuRuPr) > favouriteProcess.getProcessingTime()) {
                    Integer remainingTime = currentlyRunningProcess.getProcessingTime() - (ct-startTimeCuRuPr);
                    currentlyRunningProcess.setProcessingTime(remainingTime);
                    processQueue.add(currentlyRunningProcess);
                    schedule.add(new ScheduleItem(currentlyRunningProcess.getProcessID(), startTimeCuRuPr, ct, false));
                    currentlyRunningProcess = null;
                    startTimeCuRuPr = null;
                }
            }

            runProcess(favouriteProcess);

        }

        return schedule;
    }

    public Process getProcessSmallestProcessingTime(){
        Process favouriteProcess = processQueue.get(0);
        for(Process process : processQueue){
            if(process.getProcessingTime() < favouriteProcess.getProcessingTime()){
                favouriteProcess = process;}
            if(process.getProcessingTime() == favouriteProcess.getProcessingTime()){
                if (process.getArrivalTime() < favouriteProcess.getArrivalTime())
                    favouriteProcess = process;
            }
        }

        return favouriteProcess;
    }
}
