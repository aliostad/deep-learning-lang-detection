/*
 * This file is part of ProDisFuzz, modified on 28.08.16 19:39.
 * Copyright (c) 2013-2016 Volker Nebelung <vnebelung@prodisfuzz.net>
 * This work is free. You can redistribute it and/or modify it under the
 * terms of the Do What The Fuck You Want To Public License, Version 2,
 * as published by Sam Hocevar. See the COPYING file for more details.
 */

package model;

import model.logger.ExceptionHandler;
import model.logger.Logger;
import model.process.monitor.MonitorProcess;
import model.process.report.Process;
import model.updater.UpdateCheck;

/**
 * This class is the model component of the MVC based project structure, responsible for managing the data and logic
 * of ProDisFuzz.
 */
public enum Model {

    INSTANCE;
    private final model.process.collect.Process collectProcess;
    private final model.process.learn.Process learnProcess;
    private final model.process.export.Process exportProcess;
    private final model.process.import_.Process importProcess;
    private final MonitorProcess monitorProcess;
    private final model.process.fuzzoptions.Process fuzzOptionsProcess;
    private final model.process.fuzzing.Process fuzzingProcess;
    private final Process reportProcess;
    private final Logger logger;
    private final UpdateCheck updateCheck;

    /**
     * Constructs a new singleton model.
     */
    @SuppressWarnings("OverlyCoupledMethod")
    Model() {
        collectProcess = new model.process.collect.Process();
        learnProcess = new model.process.learn.Process();
        exportProcess = new model.process.export.Process();
        importProcess = new model.process.import_.Process();
        monitorProcess = new MonitorProcess();
        fuzzOptionsProcess = new model.process.fuzzoptions.Process();
        fuzzingProcess = new model.process.fuzzing.Process();
        reportProcess = new Process();
        logger = new Logger();
        updateCheck = new UpdateCheck();
        Thread.setDefaultUncaughtExceptionHandler(new ExceptionHandler());
    }

    /**
     * Resets all variables and options to the default by calling the reset methods of all process classes.
     */
    public void reset() {
        logger.reset();
        collectProcess.reset();
        learnProcess.reset();
        exportProcess.reset();
        importProcess.reset();
        //TODO: monitorProcess.reset();
        fuzzOptionsProcess.reset();
        fuzzingProcess.reset();
        reportProcess.reset();
    }

    /**
     * Returns the collect process that is responsible for collecting all communication files.
     *
     * @return the collect process
     */
    public model.process.collect.Process getCollectProcess() {
        return collectProcess;
    }

    /**
     * Returns the learn process that is responsible for learning the protocol structure.
     *
     * @return the learn process
     */
    public model.process.learn.Process getLearnProcess() {
        return learnProcess;
    }

    /**
     * Returns the export process that is responsible for exporting the learned protocol structure into an XML format.
     *
     * @return the export process
     */
    public model.process.export.Process getExportProcess() {
        return exportProcess;
    }

    /**
     * Returns the import process that is responsible for importing the learned protocol structure from an XML format.
     *
     * @return the import process
     */
    public model.process.import_.Process getImportProcess() {
        return importProcess;
    }

    /**
     * Returns the fuzz options process that is responsible for setting all relevant fuzzing options.
     *
     * @return the fuzz options process
     */
    public model.process.fuzzoptions.Process getFuzzOptionsProcess() {
        return fuzzOptionsProcess;
    }

    /**
     * Gets the fuzzing process, responsible for executing the fuzz testing.
     *
     * @return the fuzz options process
     */
    public model.process.fuzzing.Process getFuzzingProcess() {
        return fuzzingProcess;
    }

    /**
     * Returns the report process that is responsible for generating the final report.
     *
     * @return the report process
     */
    public Process getReportProcess() {
        return reportProcess;
    }

    /**
     * Returns the monitor process that is responsible for connecting to the monitor.
     *
     * @return the report process
     */
    public MonitorProcess getMonitorProcess() {
        return monitorProcess;
    }

    /**
     * Returns the logging mechanism that is responsible for collecting all kind of internal messages.
     *
     * @return the logger
     */
    public Logger getLogger() {
        return logger;
    }

    /**
     * Returns the update check that is responsible for checking for new releases of ProDisFuzz at prodisfuzz.net.
     *
     * @return the update check
     */
    public UpdateCheck getUpdateCheck() {
        return updateCheck;
    }
}
