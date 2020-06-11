package easypool;

public class ExportingProcess {

    private String location;

    private long processNo = 0;

    public ExportingProcess(String location, long processNo) {
        this.location = location;
        this.processNo = processNo;

        // doing some time expensive calls / tasks
        // ...

        // for-loop is just for simulation
        for (int i = 0; i < Integer.MAX_VALUE; i++) {
        }

        System.out.println("Object with process no. " + processNo + " was created");
    }

    public String getLocation() {
        return location;
    }

    public long getProcessNo() {
        return processNo;
    }

    @Override
    public String toString() {
        return "ExportingProcess{" + "processNo=" + processNo + '}';
    }
}
