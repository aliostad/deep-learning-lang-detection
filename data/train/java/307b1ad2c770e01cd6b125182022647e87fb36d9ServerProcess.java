package me.belakede.thesis.server.ui;

import javafx.beans.property.ObjectProperty;
import javafx.beans.property.SimpleObjectProperty;

public class ServerProcess {

    private final ObjectProperty<Process> process = new SimpleObjectProperty<>();

    private ServerProcess() {
        // disable constructor
    }

    public static ServerProcess getInstance() {
        return ServerProcessHolder.INSTANCE;
    }

    public Process getProcess() {
        return process.get();
    }

    public void setProcess(Process process) {
        this.process.set(process);
    }

    public ObjectProperty<Process> processProperty() {
        return process;
    }

    private static final class ServerProcessHolder {
        private static final ServerProcess INSTANCE = new ServerProcess();
    }

}
