/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package processmodeling;

import java.util.HashSet;
import java.util.Set;

/**
 * 服务器端过程图类。
 * 存储过程图中的三个过程集合，其实过程节点集合，终止过程节点集合，过程节点集合
 * @see Process
 * @author b1106
 */
public class ProcessGraph {

    private Set<Process> originProcessSet;
    private Set<Process> terminationProcessSet;
    private Set<Process> processSet;

    /**
     * 构建过程图实例，初始化过程图
     */
    public ProcessGraph() {
        originProcessSet = new HashSet<Process>();
        terminationProcessSet = new HashSet<Process>();
        processSet = new HashSet<Process>();
    }

    public Process getProcess(Process p) {
        return getP(p, processSet);
    }

    public Process getProcess(int pid) {
        return getP(pid, processSet);
    }

    public Process getOriginProcess(Process p) {
        return getP(p, originProcessSet);
    }

    public Process getTerminationProcess(Process p) {
        return getP(p, terminationProcessSet);
    }

    private Process getP(Process p, Set<Process> ps) {
        Process tmp = null;
        for (Process pp : ps) {
            if (pp.getId() == p.getId()) {
                tmp = pp;
                break;
            }
        }
        return tmp;
    }

    private Process getP(int pid, Set<Process> ps) {
        Process tmp = null;
        for (Process pp : ps) {
            if (pp.getId() == pid) {
                tmp = pp;
                break;
            }
        }
        return tmp;
    }

    public Set<Process> getOriginProcessSet() {
        return originProcessSet;
    }

    public void setOriginProcessSet(Set<Process> originProcessSet) {
        this.originProcessSet = originProcessSet;
    }

    public Set<Process> getTerminationProcessSet() {
        return terminationProcessSet;
    }

    public void setTerminationProcessSet(Set<Process> terminationProcessSet) {
        this.terminationProcessSet = terminationProcessSet;
    }

    public Set<Process> getProcessSet() {
        return processSet;
    }

    public void setProcessSet(Set<Process> processSet) {
        this.processSet = processSet;
    }
}
