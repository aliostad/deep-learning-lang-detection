/**
 * 
 */
package de.uni.stuttgart.bpelSearching.matching;


/**
 * Class MatchingResult represents a matching result. It contains informations of 
 * matching BPEL-process, and has two subclasses ExactMatchingResult and InexactMatchingResult.
 * 
 * @author luwei
 *
 */
public class MatchingResult {
	//private ProcessGraph processGraph;
	protected String processID;
	protected String processNamespace;
	protected String processName;

	/**
	 * Creates a MatchingResult object.
	 * 
	 * @param processID
	 * @param processNamespace
	 * @param processName
	 */
	public MatchingResult(String processID, String processNamespace,
			String processName) {
		super();
		this.processID = processID;
		this.processNamespace = processNamespace;
		this.processName = processName;
	}

	public String getProcessID() {
		return processID;
	}

	public void setProcessID(String processID) {
		this.processID = processID;
	}

	public String getProcessNamespace() {
		return processNamespace;
	}

	public void setProcessNamespace(String processNamespace) {
		this.processNamespace = processNamespace;
	}

	public String getProcessName() {
		return processName;
	}

	public void setProcessName(String processName) {
		this.processName = processName;
	}
}
