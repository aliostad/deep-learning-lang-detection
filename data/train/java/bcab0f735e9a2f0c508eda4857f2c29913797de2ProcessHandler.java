package org.bonitasoft.callforpaper.boslib;

public class ProcessHandler {
    public static final String USERNAME = "admin";
    private String processName;
    private String processVersion;
    static ProcessHandler processHandler;

    private ProcessHandler(String processName, String processVersion) {
        this.processName = processName;
        this.processVersion = processVersion;
    }

    public static ProcessHandler getProcessHandler(String processName, String processVersion) {
        if (processHandler==null)
            processHandler = new ProcessHandler(processName, processVersion);
        return processHandler;
    }

    public String startProcess(String email, Long id) throws Exception {
        return new ProcessStarter(USERNAME)
                .setProcessName(processName)
                .setProcessVersion(processVersion)
                .setEmail(email)
                .setId(id)
                .execute();
    }
}
