package uk.ac.ebi.fgpt.conan.service;

import uk.ac.ebi.fgpt.conan.dao.ConanProcessDAO;
import uk.ac.ebi.fgpt.conan.model.ConanProcess;

import java.util.Collection;

/**
 * Simple implementation of a process service that delegates lookup calls to a process DAO.
 *
 * @author Tony Burdett
 * @date 25-Nov-2010
 */
public class DefaultProcessService implements ConanProcessService {
    private ConanProcessDAO processDAO;

    public ConanProcessDAO getProcessDAO() {
        return processDAO;
    }

    public void setProcessDAO(ConanProcessDAO processDAO) {
        this.processDAO = processDAO;
    }

    public Collection<ConanProcess> getAllAvailableProcesses() {
        return getProcessDAO().getProcesses();
    }

    public ConanProcess getProcess(String processName) {
        return getProcessDAO().getProcess(processName);
    }
}
