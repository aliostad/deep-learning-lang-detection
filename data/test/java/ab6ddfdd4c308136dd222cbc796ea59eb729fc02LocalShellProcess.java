package com.ambimmort.app.framework.uitls.timeout;

import java.io.IOException;

/**
 * Created by hedingwei on 5/15/15.
 */
public class LocalShellProcess extends AbstractKillableProcess {


    private ProcessBuilder processBuilder ;

    private Process process = null;

    public LocalShellProcess(ProcessBuilder processBuilder){
        this.processBuilder = processBuilder;
    }

    @Override
    public void run(){
        try {
            process = processBuilder.start();
            setExitValue(process.waitFor());
        } catch (InterruptedException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    @Override
    public boolean kill() {
        try {
            process.destroy();
            return true;
        }catch (Throwable t){
            return false;
        }
    }
}
