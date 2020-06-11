package eventsystem;

import javafx.application.Platform;
import java.util.ArrayList;

public class Event {
    final ArrayList<EventContainer<EventHandler>> handlerContainers = new ArrayList<>();

    public void on(EventHandler handler) {
        handlerContainers.add(
                new EventContainer<>(handler, Thread.currentThread()));
    }

    public void off(EventHandler handler) {
        handlerContainers.removeIf(container -> container.getHandler() == handler);
    }

    public void off() {
        handlerContainers.clear();
    }

    public void fire() {
        handlerContainers.forEach(handlerContainer -> {
            if (Thread.currentThread() == handlerContainer.getThread()
                    || Platform.isFxApplicationThread())
                handlerContainer.getHandler().accept();
            else
                Platform.runLater(handlerContainer.getHandler()::accept);
        });
    }
}
