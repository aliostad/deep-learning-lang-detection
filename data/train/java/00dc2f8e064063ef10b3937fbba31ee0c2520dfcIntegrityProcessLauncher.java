package net.neandrake.windows;

class IntegrityProcessLauncher {
	private String processPath = null;
	private String processArgs = "";
	
	public IntegrityProcessLauncher(String processPath) {
		this.processPath = processPath;
	}
	
	public void setProcessArgs(String processArgs) {
		this.processArgs = processArgs;
	}
	
	public void launch() {
		if (processPath == null || processPath.isEmpty()) {
			throw new IllegalArgumentException("Cannot launch null/empty process");
		}
		if (processArgs == null) {
			throw new IllegalArgumentException("Cannot use null process arguments");
		}
		createProcessWithExplorerIntegrity(processPath, processArgs);
	}
	
	native void createProcessWithExplorerIntegrity(String processPath, String processArgs);
	
	static void init() {
		try {
			System.loadLibrary("integrityproc");
		} catch (Throwable t) {
			t.printStackTrace();
		}
	}
}