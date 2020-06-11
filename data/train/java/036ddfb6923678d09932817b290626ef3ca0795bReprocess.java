package org.beginsoft.vo;

import java.io.Serializable;

/**
 * Created by maren on 2015/5/27.
 */
public class Reprocess implements Serializable{
    private String beforeProcessId;
    private String beforeProcessName;
    private String threeProcessCode;
    private String threeProcessName;

    public String getThreeProcessCode() {
        return threeProcessCode;
    }

    public void setThreeProcessCode(String threeProcessCode) {
        this.threeProcessCode = threeProcessCode;
    }

    public String getThreeProcessName() {
        return threeProcessName;
    }

    public void setThreeProcessName(String threeProcessName) {
        this.threeProcessName = threeProcessName;
    }

    public String getBeforeProcessId() {
        return beforeProcessId;
    }

    public void setBeforeProcessId(String beforeProcessId) {
        this.beforeProcessId = beforeProcessId;
    }

    public String getBeforeProcessName() {
        return beforeProcessName;
    }

    public void setBeforeProcessName(String beforeProcessName) {
        this.beforeProcessName = beforeProcessName;
    }
}
