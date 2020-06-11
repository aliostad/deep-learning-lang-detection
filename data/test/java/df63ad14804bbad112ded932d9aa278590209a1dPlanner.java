package MOS.Scheduling;

import MOS.Process.ProcessState;
import Hardware.RealMachine;
import MOS.Process;
import MOS.Resources.Resource;
import MOS.Resources.ResourceDistributor;
import java.util.ArrayList;

/**
 * Realizuotas per PriorityQueue (nesynchronized) ir Comparatoriu (Realiai jame ir yra palyginimo logika)
 * Alternatyva:
 *   ArrayList
 *   foreach'as ieskantis geriausio
 * @author ernestas
 */
public class Planner { 
    public static ArrayList<Process> processes = new ArrayList<>(); // vaikiniai procesai
    
    /**
     * Returns Process to be executed next.
     * @return process having highest priority and is ready to work. Null if there are no processes or all are blocked
     */
    private static Process getNextProcess() {
        // TODO : Grazins is listo tinkamiausia net jei jis negali dirbti del resursu trukumo.
        // SPRENDIMAS: Arba du listai stabdyti ir galintys dirbti, arba begti per pqueue ir paimti galinti veikti (comparatoriui cia)
        for (Process p : processes) { 
            if (p.state == ProcessState.READY || p.state == ProcessState.READYS) {
                return p;
            }
        }
        return null;
    }
    
    public static void run(){
        Process process = getNextProcess();
        process.state = ProcessState.RUNNING;
        getNextProcess().run();
    }
    
    // Primityvai
    
    // <<Kurti Procesa>>
    /*
     * import Utils.*;
     */
    public static void createProcess(Process creator, Process process) {
       processes.add(process);
       creator.addChild(process); // surisa santykiu
    }
    
    public static void deleteProcess(Process process) {
        for (Resource r : process.resources) {
            ResourceDistributor.removeResource(r);
        }
        for (Process p : process.childs) {
            deleteProcess(p);  // salinami vaikai ir ju vaikai
        }
        processes.remove(process);
    }
    
    public static void changeProcessState(Process process, boolean activate) {
        if (activate) {
            if (process.state == ProcessState.BLOCKEDS) {
                process.state = ProcessState.BLOCKED;
            } else if (process.state == ProcessState.READYS) {
                process.state = ProcessState.READY;
            } 
        } else {
            if (process.state == ProcessState.BLOCKED) {
                process.state = ProcessState.BLOCKEDS;
            } else if (process.state == ProcessState.READY || process.state == ProcessState.RUNNING) {
                process.state = ProcessState.READYS;
            }
        }
    }
    
}
