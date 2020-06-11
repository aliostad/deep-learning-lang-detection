/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package com.viettel.ccdt.oracle.persitent.clazz;

import java.sql.Timestamp;
import java.util.Date;

/**
 *
 * @author phucdk
 */
public class ProcessConfigInOutBO {
    private Long processConfigInOutId;
    private Timestamp processTime;    

    public Long getProcessConfigInOutId() {
        return processConfigInOutId;
    }

    public void setProcessConfigInOutId(Long processConfigInOutId) {
        this.processConfigInOutId = processConfigInOutId;
    }    

    public Timestamp getProcessTime() {
        return processTime;
    }

    public void setProcessTime(Timestamp processTime) {
        this.processTime = processTime;
    }
    
}
