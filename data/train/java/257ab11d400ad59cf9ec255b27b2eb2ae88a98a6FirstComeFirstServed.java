import java.util.ArrayList;

public class FirstComeFirstServed extends AlgStrategies {

    public static ArrayList<Process> FirstComeFirstServed(ArrayList<Process> list) {

        Process process;
        ArrayList<Process> processList = new ArrayList<>(list);
        ArrayList<Process> processResult = new ArrayList<>();

        for (int i = 0; i < 100; i++) {
            if (!processList.isEmpty()) {
                process = processList.get(processList.size() - 1);
                if (process.getArrivalTime() <= i) {
                    if (!process.isResponseTimeSet()) {
                        process.setResponseTime(i);
                    }
                    process.setIsDone();
                    if (process.isDone()) {
                        process.setCompleteTime(i);
                        processList.remove(processList.size() - 1);
                        processResult.add(process);
                    }
                } 
            } else {
                break;
            }
        }
        return processResult;
    }
}
