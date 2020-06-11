package messenger.messaging;

import java.io.File;
import java.io.IOException;
import static messenger.messaging.Configurations.*;

public class ProcessFactory {

    private static Process messageListenerProcess;

    private static ProcessBuilder getProcessBuilder() {

        ProcessBuilder processBuilder = new ProcessBuilder();
        processBuilder.directory(new File(Configurations.YOWSUP_HOME));
        return processBuilder;
    }

    public static Process getProcessMessageListener() throws IOException {
        if (messageListenerProcess != null) {
            try {
                messageListenerProcess.exitValue();
            } catch (IllegalThreadStateException e) {
                return messageListenerProcess;
            }
        }
        ProcessBuilder processBuilder = getProcessBuilder();
        String[] listenCommand = { "cmd", "/C", LISTEN_COMMAND };

        processBuilder.command(listenCommand);
        messageListenerProcess = processBuilder.start();
        return messageListenerProcess;
    }

    // public static Process getProcessForSendingMessage(String numbers, String
    // message) throws IOException {
    // String[] sendCommand = { "/bin/bash", (new File("")).getCanonicalPath() +
    // "/" + SEND_COMMAND, numbers, message };
    // ProcessBuilder processBuilder = getProcessBuilder();
    // processBuilder.command(sendCommand);
    // return processBuilder.start();
    // }
}
