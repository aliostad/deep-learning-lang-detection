import java.util.LinkedList;
import java.util.List;

public class CPU {

    private int index;
    private LinkedList<Process> processQueue;
    private Process processRunning;
    private int qtdeAllowedProcess = 3;
    private int queueSize;

    public CPU(int index, int queueSize) {
        this.index = index;
        this.queueSize = queueSize;
        processQueue = new LinkedList<Process>();
        processRunning = null;
    }

    public boolean isIdle(){
        return processRunning == null;
    }

    public void addProcess(Process process) {
        if(isIdle())
            processRunning = process;
        else
            processQueue.add(process);
    }

    public boolean update() {
        if(isIdle())
            return false;
        processRunning.consumeOneClock();
        if(processRunning.processFinished()){
            if(processQueue.isEmpty())
                processRunning = null;
            else
                processRunning = processQueue.remove();
            return true;
        }
        return false;
    }

    public boolean isOverloaded() {
        return processQueue.size() >= qtdeAllowedProcess;
    }

    public boolean doesAcceptProcess() {
        return !isOverloaded();
    }

    public int getIndex() {
        return index;
    }

    public boolean hasProcessWaiting(){
        return processQueue.size() > 0;
    }

    public Process getLastProcess(){
        return processQueue.getLast();
    }

    public void deleteLastProcess(){
        processQueue.remove(processQueue.size()-1);
    }

    @Override
    public String toString() {
        return "CPU-" + index;
    }

    public void printState() {
        StringBuilder sb = new StringBuilder();
        if (processRunning != null)
            sb.append("y");
        else
            sb.append("n");
        for (Process process : processQueue) {
            sb.append(process).append(" ");
        }
        System.out.println(this + ": " + sb);
    }
}
