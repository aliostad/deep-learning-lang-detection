/*
 * The meta data of process
 */
public class ProcessMeta {	
	private String _processName;
	private int _id;
	private String _hostName;
	
	public ProcessMeta(String pn, int id, String hn) {
		this._processName = pn;
		this._id = id;
		this._hostName = hn;
	}
	
	public String getProcessName() {
		return this._processName;
	}
	
	public int getProcessId() {
		return this._id;
	}
	
	public String getHostName() {
		return this._hostName;
	}
	
	public void printProcessInfo() {
		System.out.println("process Id: "+this._id+" process name: "+this._processName);
	}
}
