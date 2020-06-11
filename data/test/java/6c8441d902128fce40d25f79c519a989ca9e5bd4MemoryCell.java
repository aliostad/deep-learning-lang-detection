package bean;

/**
 *
 * @author Fabricio Reis
 */
public class MemoryCell {
    private boolean isFree;
    private Process process;
    private int size;

    public MemoryCell() {
    }
    
    public MemoryCell(boolean isFree, Process process, int size) {
        this.size = size;
        this.isFree = isFree;
        this.process = process;
    }

    public boolean isIsFree() {
        return isFree;
    }

    public void setIsFree(boolean isFree) {
        this.isFree = isFree;
    }

    public Process getProcess() {
        if(this.isFree) {
            return null;
        }
        else {
            return process;
        }
    }

    public void setProcess(Process process) {
        if(this.isFree) {
            this.process = null;
        }
        else {
            this.process = process;
        }
    }    
    
    public int getSize() {
        return size;
    }

    public void setSize(int size) {
        this.size = size;
    }
}
