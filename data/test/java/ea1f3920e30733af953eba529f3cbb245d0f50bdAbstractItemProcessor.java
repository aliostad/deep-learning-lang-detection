package traverser;

import java.util.HashSet;
import java.util.Set;

public abstract class AbstractItemProcessor implements ItemProcessor {

	private Set<ProcessFinishedListener> listeners;

	public AbstractItemProcessor() {
		listeners = new HashSet<ProcessFinishedListener>();
	}

	public void registerProcessFinishedListener(ProcessFinishedListener listener) {
		listeners.add(listener);
	}

	@Override
	public void process(Item it) {
		ProcessResult result = internalProcess(it);
		for (ProcessFinishedListener l : listeners) {
			l.processFinished(result);
		}
	}

	protected abstract ProcessResult internalProcess(Item it);
}
