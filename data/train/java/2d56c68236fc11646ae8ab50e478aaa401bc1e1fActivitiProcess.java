package chenix.activiti;

/**
 * Created by mbonanata on 05/05/15.
 *
 * Enum para modelar los distintos procesos
 */
public enum ActivitiProcess {

    SALE("processes/sale.bpmn", "sale", "sale");

    final private String processFilePath;
    final private String processName;
    final private String processKey;

    ActivitiProcess(String processFilePath, String processName, String processKey) {
        this.processFilePath = processFilePath;
        this.processName = processName;
        this.processKey = processKey;
    }

    public String getProcessFilePath() {
        return processFilePath;
    }

    public String getProcessName() {
        return processName;
    }

    public String getProcessKey() {
        return this.processKey;
    }
}
