package ru.taskurotta.service;

import ru.taskurotta.service.config.ConfigService;
import ru.taskurotta.service.config.impl.MemoryConfigService;
import ru.taskurotta.service.dependency.DependencyService;
import ru.taskurotta.service.dependency.GeneralDependencyService;
import ru.taskurotta.service.dependency.links.MemoryGraphDao;
import ru.taskurotta.service.gc.GarbageCollectorService;
import ru.taskurotta.service.gc.MemoryGarbageCollectorService;
import ru.taskurotta.service.queue.MemoryQueueService;
import ru.taskurotta.service.queue.QueueService;
import ru.taskurotta.service.storage.*;

/**
 * User: romario
 * Date: 4/1/13
 * Time: 4:30 PM
 */
public class MemoryServiceBundle implements ServiceBundle {

    private ProcessService processService;
    private TaskService taskService;
    private QueueService queueService;
    private DependencyService dependencyService;
    private ConfigService configService;
    private MemoryGraphDao memoryGraphDao;
    private InterruptedTasksService interruptedTasksService;
    private MemoryGarbageCollectorService garbageCollectorService;

    public MemoryServiceBundle(int pollDelay, TaskDao taskDao) {
        this.processService = new MemoryProcessService();
        this.taskService = new GeneralTaskService(taskDao, 30000);
        this.queueService = new MemoryQueueService(pollDelay);
        this.memoryGraphDao = new MemoryGraphDao();
        this.dependencyService = new GeneralDependencyService(memoryGraphDao);
        this.configService = new MemoryConfigService();
        this.interruptedTasksService = new MemoryInterruptedTasksService();
        this.garbageCollectorService = new MemoryGarbageCollectorService(processService, memoryGraphDao, taskDao, 1);
    }

    @Override
    public ProcessService getProcessService() {
        return processService;
    }

    @Override
    public TaskService getTaskService() {
        return taskService;
    }

    @Override
    public QueueService getQueueService() {
        return queueService;
    }

    @Override
    public DependencyService getDependencyService() {
        return dependencyService;
    }

    @Override
    public ConfigService getConfigService() {
        return configService;
    }

    @Override
    public InterruptedTasksService getInterruptedTasksService() {
        return interruptedTasksService;
    }

    @Override
    public GarbageCollectorService getGarbageCollectorService() {
        return garbageCollectorService;
    }

    public MemoryGraphDao getMemoryGraphDao() {
        return memoryGraphDao;
    }
}
