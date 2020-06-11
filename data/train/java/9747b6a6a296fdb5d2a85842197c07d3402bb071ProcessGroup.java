package pwall;

import pwall.Process;
import java.util.ArrayList;
import java.util.Random;

public class ProcessGroup extends ArrayList<Process>
{
    public void startAll()
    {
        for (Process process : this) {
            process.startWork();
        }
    }

    public void pauseAll()
    {
        for (Process process : this) {
            process.pauseWork();
        }
    }

    public void stopAll()
    {
        for (Process process : this) {
            process.stopWork();
        }
    }

    public void resetAll()
    {
        for (Process process : this) {
            process.reset();
        }
    }

    public ProcessGroup someMajority() {
        Random randomizer = new Random();
        ProcessGroup result = new ProcessGroup();
        result.addAll(this);

        int majority = size() / 2 + 1;
        while (result.size() > majority) {
            result.remove(randomizer.nextInt(result.size()));
        }
        return result;
    }
}

