package schedule.queue;

import java.util.Arrays;

import schedule.ProcessType;

public enum QueueType {
	QUEUE_SYSTEM("system", 2, ProcessType.SYSTEM_PROCESS),
	QUEUE_BACKGROUND("background", 3, ProcessType.BACKGROUND_PROCESS),
	QUEUE_BATCH("batch", 4, ProcessType.BATCH_PROCESS), 
	QUEUE_INTERACTIVE("interactive", 1, ProcessType.INTERACTIVE_PROCESS);

	private String name;
	private int priority;
	private ProcessType[] processTypes;

	private QueueType(String name, int priority, ProcessType... processTypes) {
		this.name = name;
		this.priority = priority;
		this.processTypes = processTypes;
	}

	public int getPriority() {
		return priority;
	}

	public String getName() {
		return name;
	}
	
	public ProcessType[] getProcessTypes() {
		return processTypes;
	}

	public static QueueType getByName(String name) {
		for (QueueType queueType : values()) {
			if (queueType.name.equals(name)) {
				return queueType;
			}
		}
		return null;
	}
	
	public static QueueType getByProcessType(ProcessType processType) {
		for (QueueType queueType : values()) {
			if (Arrays.asList(queueType.processTypes).contains(processType)) {
				return queueType;
			}
		}
		return null;
	}
}
