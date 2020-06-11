package core.cq.hmq.pojo;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

//@Entity
public class ProcessXml {

	@Id
	@GeneratedValue(strategy = GenerationType.AUTO)
	private Long id;

	private String processId;

	private String processName;

	@Column(length = 10000)
	private String processXml;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getProcessId() {
		return processId;
	}

	public void setProcessId(String processId) {
		this.processId = processId;
	}

	public String getProcessName() {
		return processName;
	}

	public void setProcessName(String processName) {
		this.processName = processName;
	}

	public String getProcessXml() {
		return processXml;
	}

	public void setProcessXml(String processXml) {
		this.processXml = processXml;
	}
}
