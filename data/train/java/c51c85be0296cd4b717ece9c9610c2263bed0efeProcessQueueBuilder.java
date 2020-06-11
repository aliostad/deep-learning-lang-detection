/**
 * Copyright 2012-2013 Mateusz Kubuszok
 *
 * <p>Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at</p> 
 * 
 * <p>http://www.apache.org/licenses/LICENSE-2.0</p>
 *
 * <p>Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.</p>
 */
package net.jsdpu.process.queue;

import static java.util.Arrays.asList;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import net.jsdpu.process.elevated.ElevatedProcessBuilder;

/**
 * Class responsible for building process queue that can be run as a single
 * process and elevated.
 */
public class ProcessQueueBuilder {
    private final ArrayList<ProcessBuilder> processBuilders;
    private final Map<ElevatedProcessBuilder, ProcessBuilder> elevatedProcessBuilders;

    /**
     * Creates builder that allows running several processes as one.
     */
    public ProcessQueueBuilder() {
        processBuilders = new ArrayList<ProcessBuilder>();
        elevatedProcessBuilders = new HashMap<ElevatedProcessBuilder, ProcessBuilder>();
    }

    /**
     * Enqueues ProcessBuilders for queue.
     * 
     * @param processBuilders
     *            builders to be enqueued
     * @return this builder allowing chaining
     */
    public ProcessQueueBuilder enqueue(ProcessBuilder... processBuilders) {
        this.processBuilders.addAll(asList(processBuilders));
        return this;
    }

    /**
     * Enqueues ElevatedProcessBuilders for queue.
     * 
     * @param elevatedProcessBuilders
     *            builders to be enqueued
     * @return this builder allowing chaining
     */
    public ProcessQueueBuilder enqueue(ElevatedProcessBuilder... elevatedProcessBuilders) {
        for (ElevatedProcessBuilder elevatedProcessBuilder : elevatedProcessBuilders) {
            ProcessBuilder processBuilder = elevatedProcessBuilder.getProcessBuilder();
            this.elevatedProcessBuilders.put(elevatedProcessBuilder, processBuilder);
            processBuilders.add(processBuilder);
        }
        return this;
    }

    /**
     * Dequeues ProcessBuilders for queue.
     * 
     * @param processBuilders
     *            builders to be dequeued
     * @return this builder allowing chaining
     */
    public ProcessQueueBuilder dequeue(ProcessBuilder... processBuilders) {
        this.processBuilders.removeAll(asList(processBuilders));
        return this;
    }

    /**
     * Dequeues ElevatedProcessBuilders for queue.
     * 
     * @param elevatedProcessBuilders
     *            builders to be dequeued
     * @return this builder allowing chaining
     */
    public ProcessQueueBuilder dequeue(ElevatedProcessBuilder... elevatedProcessBuilders) {
        for (ElevatedProcessBuilder elevatedProcessBuilder : elevatedProcessBuilders)
            if (this.elevatedProcessBuilders.containsKey(elevatedProcessBuilder)) {
                ProcessBuilder processBuilder = this.elevatedProcessBuilders
                        .get(elevatedProcessBuilder);
                this.processBuilders.remove(processBuilder);
                this.elevatedProcessBuilders.remove(elevatedProcessBuilder);
            }
        return this;
    }

    /**
     * Returns process queue.
     * 
     * @return ProcessQueue
     */
    public ProcessQueue build() {
        // TODO: write it one day
        throw new UnsupportedOperationException("Not yet implemented!");
    }
}
