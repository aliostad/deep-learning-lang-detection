// Run() is called from Scheduling.main() and is where
// the scheduling algorithm written by the user resides.
// User modification should occur within the Run() function.


import java.util.Vector;
import java.io.*;

public class SchedulingAlgorithm {


  public static Results Run(int runtime, Vector <sProcess> processVector, Results result) {
    int i = 0;
    int comptime = 0;
    int currentProcess = 0;
    int previousProcess = 0;
    int size = processVector.size();
    int completed = 0;
    String resultsFile = "/Users/flystyle/Documents/Java Projects/L3.SPOS.Guaranteed Scheduler/src/Summary-Results";

    result.schedulingType = "Batch (Nonpreemptive)";
    result.schedulingName = "Guaranteed";
    try {
      PrintStream out = new PrintStream(new FileOutputStream(resultsFile));
      sProcess process = (sProcess) processVector.elementAt(currentProcess);
      out.println("Process: " + currentProcess + " registered... (" + process.cputime + " " + process.ioblocking + " " + process.cpudone + " " + process.cpudone + ")");
      while (comptime < runtime) {
        if (process.cpudone == process.cputime) {
          completed++;
          out.println("Process: " + currentProcess + " completed... (" + process.cputime + " " + process.ioblocking + " " + process.cpudone + " " + process.cpudone + ")");
          if (completed == size) {
            result.compuTime = comptime;
            out.close();
            return result;
          }
//          for (i = size - 1; i >= 0; i--) {
//            process = (sProcess) processVector.elementAt(i);
//            if (process.cpudone < process.cputime) {
//              currentProcess = i;
//            }
//          }
          float val = Float.MAX_VALUE;
          int ratio = Integer.MAX_VALUE;
          float allRatio = runtime/processVector.size();
          for (int j = 0; j < processVector.size(); j++) {
            if (processVector.get(j).cputime - processVector.get(j).cpudone != 0)
              if(processVector.get(j).rating < ratio) {
                if (allRatio / (processVector.get(j).cputime - processVector.get(j).cpudone) < val) {
                    ratio = processVector.get(j).rating;
                    currentProcess = j;
                  }
                }
          }
          process = (sProcess) processVector.elementAt(currentProcess);
          out.println("Process: " + currentProcess + " registered... (" + process.cputime + " " + process.ioblocking + " " + process.cpudone + " " + process.cpudone + ")");
        }
        if (process.ioblocking == process.ionext) {
          out.println("Process: " + currentProcess + " I/O blocked... (" + process.cputime + " " + process.ioblocking + " " + process.cpudone + " " + process.cpudone + ")");
          process.numblocked++;
          process.ionext = 0;
          previousProcess = currentProcess;
//          for (i = size - 1; i >= 0; i--) {
//            process = (sProcess) processVector.elementAt(i);
//            if (process.cpudone < process.cputime && previousProcess != i) {
//              currentProcess = i;
//            }
//          }
          float val = Integer.MAX_VALUE;
          int ratio = Integer.MAX_VALUE;
          float allRatio = runtime/processVector.size();
          for (int j = 0; j < processVector.size(); j++) {
            if (processVector.get(j).cputime - processVector.get(j).cpudone != 0)
            if (allRatio/(processVector.get(j).cputime - processVector.get(j).cpudone) < val && previousProcess != j) {
              if(processVector.get(j).rating < ratio) {
                val = allRatio / (processVector.get(j).cputime - processVector.get(j).cpudone);
                  ratio = processVector.get(j).rating;
                  currentProcess = j;
                }
              }
            }
          process = (sProcess) processVector.elementAt(currentProcess);
          out.println("Process: " + currentProcess + " registered... (" + process.cputime + " " + process.ioblocking + " " + process.cpudone + " " + process.cpudone + ")");
        }

        process.cpudone++;
        if (process.ioblocking > 0) {
          process.ionext++;
        }
        comptime++;
      }
      out.close();
    } catch (IOException e) { /* Handle exceptions */ }
    result.compuTime = comptime;
    return result;
  }
}
