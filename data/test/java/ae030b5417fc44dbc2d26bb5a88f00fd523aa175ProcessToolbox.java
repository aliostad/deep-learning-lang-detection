package com.santos.toolbox;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.logging.Logger;

import org.bonitasoft.engine.api.ProcessAPI;
import org.bonitasoft.engine.bpm.process.ProcessActivationException;
import org.bonitasoft.engine.bpm.process.ProcessDefinitionNotFoundException;
import org.bonitasoft.engine.bpm.process.ProcessExecutionException;
import org.bonitasoft.log.event.BEvent;
import org.bonitasoft.log.event.BEvent.Level;

public class ProcessToolbox {

    private static Logger logger = Logger.getLogger("org.bonitasoft.ProcessToolbox");

    private static final BEvent eventProcessNotExist = new BEvent(ProcessToolbox.class.getName(), 1, Level.APPLICATIONERROR,
            "Process not exist", "The process does not exist",
            "Create a process");

    private static final BEvent eventNotActivated = new BEvent(ProcessToolbox.class.getName(), 2, Level.APPLICATIONERROR,
            "Process not activated", "The process is not activated",
            "Activate the process");
    private static final BEvent eventCantStartProcess = new BEvent(ProcessToolbox.class.getName(), 1, Level.APPLICATIONERROR,
            "Can't start a process", "An error arrive at startup",
            "Check the log");

    /** start a case in the giving process */
    public static class ProcessToolboxResult
    {

        public Long processInstance = null;
        public List<BEvent> listEvents = new ArrayList<BEvent>();
    }

    /**
     * startACase
     * 
     * @param processDefinitionName
     * @param variables
     * @param processAPI
     * @return
     */
    public static ProcessToolboxResult startACase(final String processDefinitionName, final Map<String, Serializable> variables, final ProcessAPI processAPI)
    {
        logger.info("Santos.ProcessToolbox : Start process [" + processDefinitionName + "]");
        final ProcessToolboxResult processToolboxResult = new ProcessToolboxResult();
        try {
            final long processDefinitionId = processAPI.getLatestProcessDefinitionId(processDefinitionName);

            processToolboxResult.processInstance = processAPI.startProcess(processDefinitionId, variables).getId();
            return processToolboxResult;

        } catch (final ProcessDefinitionNotFoundException e) {
            logger.severe("Santos.ProcessToolbox : ProcessNotFound process [" + processDefinitionName + "] " + e.toString());
            processToolboxResult.listEvents.add(new BEvent(eventProcessNotExist, "Process name [" + processDefinitionName + "]"));
        } catch (final ProcessActivationException e) {
            logger.severe("Santos.ProcessToolbox : ProcessNotActivated process [" + processDefinitionName + "] " + e.toString());
            processToolboxResult.listEvents.add(new BEvent(eventNotActivated, "Process name [" + processDefinitionName + "]"));
        } catch (final ProcessExecutionException e) {
            logger.severe("Santos.ProcessToolbox : ProcessStartError process [" + processDefinitionName + "] " + e.toString());
            processToolboxResult.listEvents.add(new BEvent(eventCantStartProcess, "Process name [" + processDefinitionName + "]"));
        }
        return processToolboxResult;
    }
}
