/*******************************************************************************
 * PageFlow Dynamic Workflow Engine
 ******************************************************************************/
package pageflow.model;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Lob;
import javax.persistence.OneToMany;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

import org.hibernate.annotations.LazyCollection;
import org.hibernate.annotations.LazyCollectionOption;

/**
 * The persistent class for the vw_processes database view.
 */
@Entity
@Table(name = "vw_processes")
@SuppressWarnings("serial")
public class Process extends BaseEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    @Column(name = "process_id")
    private int processId;

    @Column(name = "process_name")
    private String processName;

    @Column(name = "process_description")
    private String processDescription;

    @Column(name = "process_display_name")
    private String processDisplayName;

    @Column(name = "process_ord_index")
    private Integer processOrdIndex;

    @Column(name = "process_page_override")
    private String processPageOverride;

    @Column(name = "process_start_date")
    @Temporal(TemporalType.TIMESTAMP)
    private Date processStartDate;

    @Column(name = "process_end_date")
    @Temporal(TemporalType.TIMESTAMP)
    private Date processEndDate;

    @Lob
    @Column(name = "process_icon")
    private byte[] processIcon;

    @Column(name = "process_status")
    private String processStatus;

    /* Child Sequences */
    @OneToMany(mappedBy = "process", cascade = CascadeType.ALL)
    @LazyCollection(LazyCollectionOption.FALSE)
    private List<Sequence> sequences;

    public Process() {
    }

    public String getProcessDescription() {
        return this.processDescription;
    }

    public void setProcessDescription(String processDescription) {
        this.processDescription = processDescription;
    }

    public String getProcessDisplayName() {
        return this.processDisplayName;
    }

    public void setProcessDisplayName(String processDisplayName) {
        this.processDisplayName = processDisplayName;
    }

    public Date getProcessEndDate() {
        return this.processEndDate;
    }

    public void setProcessEndDate(Date processEndDate) {
        this.processEndDate = processEndDate;
    }

    public byte[] getProcessIcon() {
        return this.processIcon;
    }

    public void setProcessIcon(byte[] processIcon) {
        this.processIcon = processIcon;
    }

    public int getProcessId() {
        return this.processId;
    }

    public void setProcessId(int processId) {
        this.processId = processId;
    }

    public String getProcessName() {
        return this.processName;
    }

    public void setProcessName(String processName) {
        this.processName = processName;
    }

    public Integer getProcessOrdIndex() {
        if (null == this.processOrdIndex) {
            this.processOrdIndex = Integer.MAX_VALUE;
        }
        return this.processOrdIndex;
    }

    public void setProcessOrdIndex(Integer processOrdIndex) {
        this.processOrdIndex = processOrdIndex;
    }

    public String getProcessPageOverride() {
        return this.processPageOverride;
    }

    public void setProcessPageOverride(String processPageOverride) {
        this.processPageOverride = processPageOverride;
    }

    public Date getProcessStartDate() {
        return this.processStartDate;
    }

    public void setProcessStartDate(Date processStartDate) {
        this.processStartDate = processStartDate;
    }

    public String getProcessStatus() {
        return this.processStatus;
    }

    public void setProcessStatus(String processStatus) {
        this.processStatus = processStatus;
    }

    public List<Sequence> getSequences() {
        if (sequences == null) {
            this.sequences = new ArrayList<Sequence>();
        }
        return sequences;
    }

    public void setSequences(List<Sequence> sequences) {
        this.sequences = sequences;
    }

    public String toString() {
        return "Process [Id=" + processId + ", Name=" + processName + ", Status="
                + processStatus + "]";
    }

    public int hashCode() {
        final int prime = 31;
        int result = 1;
        result = prime * result + processId;
        result = prime * result + ((processName == null) ? 0 : processName.hashCode());
        return result;
    }

    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        }
        if (obj == null) {
            return false;
        }
        if (getClass() != obj.getClass()) {
            return false;
        }
        Process other = (Process) obj;
        if (processId != other.processId) {
            return false;
        }
        if (processName == null) {
            if (other.processName != null) {
                return false;
            }
        } else if (!processName.equals(other.processName)) {
            return false;
        }
        return true;
    }
}
