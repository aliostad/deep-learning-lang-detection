package uni.praktikum.rechnernetze.carrace.server.handler;

import uni.praktikum.rechnernetze.carrace.server.materials.Race;

import java.util.HashSet;
import java.util.Set;

public class RaceHandler implements Runnable {

    private Set<StateHandler> stateHandler;

    public RaceHandler(Race race) {
        this.stateHandler = new HashSet<StateHandler>();
        stateHandler.add(new SetupStateHandler(race));
        stateHandler.add(new RunningStateHandler(race));
        stateHandler.add(new FinishedStateHandler(race));
    }

    public void run() {

        while (true) {
            for (StateHandler stateHandler : this.stateHandler) {
                stateHandler.handleRace();
            }
            try {
                Thread.currentThread().sleep(1000);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
    }
}