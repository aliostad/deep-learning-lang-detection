package cz.cuni.mff.d3s.jdeeco.cloudsimulator.timers;

import java.util.ArrayList;
import java.util.List;

public class AggregateTimerHandler implements TimerHandler {

	private final List<TimerHandler> handlers = new ArrayList<>();

	public void addHandler(TimerHandler handler) {
		synchronized (handlers) {
			handlers.add(handler);
		}
	}

	public void removeHandler(TimerHandler handler) {
		synchronized (handlers) {
			handlers.remove(handler);
		}
	}

	@Override
	public void start(String id) {
		synchronized (handlers) {
			for (TimerHandler handler : handlers) {
				handler.start(id);
			}
		}
	}

	@Override
	public void stop(String id) {
		synchronized (handlers) {
			for (TimerHandler handler : handlers) {
				handler.stop(id);
			}
		}
	}

	@Override
	public void reset(String id) {
		synchronized (handlers) {
			for (TimerHandler handler : handlers) {
				handler.reset(id);
			}
		}
	}
}
