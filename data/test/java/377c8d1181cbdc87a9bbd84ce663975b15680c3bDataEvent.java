package eventsystem;

import javafx.application.Platform;

import java.util.HashSet;
import java.util.Set;
import java.util.function.Consumer;

public class DataEvent<T> {
    final Set<EventContainer<Consumer<T>>> handlerContainers = new HashSet<>();

    public void on(Consumer<T> handler) {
        handlerContainers.add(
                new EventContainer<>(handler, Thread.currentThread()));
    }

    public void off(EventHandler handler) {
        handlerContainers.removeIf(container -> container.getHandler() == handler);
    }

    public void off() {
        handlerContainers.clear();
    }

    public void fire(T data) {
        handlerContainers.forEach(handlerContainer -> {
            if (Thread.currentThread() == handlerContainer.getThread()
                    || Platform.isFxApplicationThread())
                handlerContainer.getHandler().accept(data);
            else
                Platform.runLater(() -> handlerContainer.getHandler().accept(data));
        });
    }
}
