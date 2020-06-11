package org.dclayer.listener.net;

import org.dclayer.net.process.template.Process;

/**
 * used to spawn {@link Process}es from another Process as a reaction to a received message
 */
public interface ReceiveFollowUpProcessSpawnInterface {
	/**
	 * adds a receive-follow-up Process (a Process that is spawned by another Process upon receipt)
	 * @param originalProcess the Process that spawns this receive-follow-up Process
	 * @param followUpProcess the new Process to spawn
	 */
	public void addReceiveFollowUpProcess(Process originalProcess, Process followUpProcess);
}
