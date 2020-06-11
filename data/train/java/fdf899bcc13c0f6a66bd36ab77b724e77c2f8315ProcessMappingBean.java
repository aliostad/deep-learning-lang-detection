package au.edu.unsw.cse.model;

public class ProcessMappingBean {

	int RowID;
	int ProcessID;
	String ProcessName;

	public ProcessMappingBean() {
		super();
	}

	public ProcessMappingBean(int rowID, int processID, String processName) {
		super();
		RowID = rowID;
		ProcessID = processID;
		ProcessName = processName;
	}

	/**
	 * @return the rowID
	 */
	public int getRowID() {
		return RowID;
	}

	/**
	 * @param rowID
	 *            the rowID to set
	 */
	public void setRowID(int rowID) {
		RowID = rowID;
	}

	/**
	 * @return the processID
	 */
	public int getProcessID() {
		return ProcessID;
	}

	/**
	 * @param processID
	 *            the processID to set
	 */
	public void setProcessID(int processID) {
		ProcessID = processID;
	}

	/**
	 * @return the processName
	 */
	public String getProcessName() {
		return ProcessName;
	}

	/**
	 * @param processName
	 *            the processName to set
	 */
	public void setProcessName(String processName) {
		ProcessName = processName;
	}

}
