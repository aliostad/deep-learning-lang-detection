package utils;

import base.Process;
import process.DistributedTask;

import java.util.concurrent.*;

/**
 * Created with IntelliJ IDEA.
 * User: paul
 * Date: 3/13/13
 * Time: 9:34 PM
 */
public class HeartbeatTask implements Runnable {

    private Process process;


    private HeartbeatTask(Process process) {
        this.process = process;
    }

    public static HeartbeatTask getInstance(Process forProcess) {
        return new HeartbeatTask(forProcess);
    }

    @Override
    public void run() {
        this.process.broadcast( "HEARTBEAT", String.valueOf(System.currentTimeMillis()) );
    }
}
