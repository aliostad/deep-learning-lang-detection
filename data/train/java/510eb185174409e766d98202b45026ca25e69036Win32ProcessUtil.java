/*
 * Created On:  Nov 19, 2007 12:59:36 PM
 */
package com.thinkparity.ophelia.support.util.process.win32;

import java.util.ArrayList;
import java.util.List;

import com.thinkparity.codebase.log4j.Log4JWrapper;

import com.thinkparity.ophelia.support.util.process.ProcessException;
import com.thinkparity.ophelia.support.util.process.ProcessInfo;
import com.thinkparity.ophelia.support.util.process.ProcessUtil;

/**
 * <b>Title:</b><br>
 * <b>Description:</b><br>
 * @author raymond@thinkparity.com
 * @version 1.1.2.1
 */
public class Win32ProcessUtil implements ProcessUtil {

    /** A loaded flag. */
    private static boolean loaded;

    /** A library name. */
    private static final String PROCESS_UTIL_LIBNAME;

    static {
        PROCESS_UTIL_LIBNAME = "Win32ProcessUtil";

        loaded = false;
        try {
            System.loadLibrary(PROCESS_UTIL_LIBNAME);
            loaded = true;
        } catch (final Throwable t) {
            t.printStackTrace(System.err);
        }
    }

    /**
     * Instantiate a process exception for an unloaded library.
     * 
     * @return A <code>ProcessException</code>.
     */
    private static ProcessException newProcessExceptionLoad() {
        return new ProcessException("Process util native library was not loaded.");
    }

    /** A log4j wrapper. */
    private final Log4JWrapper logger;

    /**
     * Create Win32ProcessUtil.
     *
     */
    public Win32ProcessUtil() {
        super();
        this.logger = new Log4JWrapper(getClass());
    }

    /**
     * @see com.thinkparity.ophelia.support.util.process.ProcessUtil#terminate()
     *
     */
    public String getProcessId() throws ProcessException {
        if (loaded) {
            return String.valueOf(getCurrentProcessId());
        } else {
            throw newProcessExceptionLoad();
        }
    }

    /**
     * @see com.thinkparity.ophelia.support.util.process.ProcessUtil#getProcessList()
     * 
     */
    @Override
    public List<ProcessInfo> getProcessList() throws ProcessException {
        if (loaded) {
            if (createProcessSnapshot()) {
                try {
                    final List<ProcessInfo> processList = new ArrayList<ProcessInfo>();

                    int processSnapshotId, processSnapshotParentId;
                    String processSnapshotExeFile;
                    ProcessInfo process;
                    while (nextSnapshotProcess()) {
                        processSnapshotId = getProcessSnapshotId();
                        processSnapshotParentId = getProcessSnapshotParentId();
                        processSnapshotExeFile = getProcessSnapshotExeFile();
                        logger.logVariable("processSnapshotId", processSnapshotId);
                        logger.logVariable("processSnapshotParentId", processSnapshotParentId);
                        logger.logVariable("processSnapshotExeFile", processSnapshotExeFile);
                        process = new ProcessInfo();
                        process.setFile(processSnapshotExeFile);
                        process.setId(String.valueOf(processSnapshotId));
                        process.setParentId(String.valueOf(processSnapshotParentId));
                        processList.add(process);
                    }
                    return processList;
                } finally {
                    deleteProcessSnapshot();
                }
            } else {
                throw new ProcessException("Could not create process snapshot.");
            }
        } else {
            throw newProcessExceptionLoad();
        }
    }
    
    /**
     * @see com.thinkparity.ophelia.support.util.process.ProcessUtil#isLoaded()
     *
     */
    public Boolean isLoaded() {
        return Boolean.valueOf(loaded);
    }

    /**
     * @see com.thinkparity.ophelia.support.util.process.ProcessUtil#terminate(java.lang.String)
     *
     */
    @Override
    public Boolean terminate(final String id) throws ProcessException {
        if (loaded) {
            return Boolean.valueOf(terminate(Integer.valueOf(id).intValue()));
        } else {
            throw newProcessExceptionLoad();
        }
    }

    /**
     * Create a process snapshot.
     *
     */
    private native boolean createProcessSnapshot();

    /**
     * Delete the process snapshot.
     *
     */
    private native boolean deleteProcessSnapshot();

    /**
     * Obtain the current process id.
     * 
     * @return An <code>int</code>.
     */
    private native int getCurrentProcessId();

    /**
     * Obtain the snapshot's current process name.
     * 
     * @return A <code>String</code>.
     */
    private native String getProcessSnapshotExeFile();

    /**
     * Obtain the snapshot's current process id.
     * 
     * @return An <code>int</code>.
     */
    private native int getProcessSnapshotId();

    /**
     * Obtain the snapshot's current process' parent process id.
     * 
     * @return An <code>int</code>.
     */
    private native int getProcessSnapshotParentId();

    /**
     * Iterate to the next snapshot process.
     * 
     * @return True if the move suceeded.
     */
    private native boolean nextSnapshotProcess();

    /**
     * Terminate a process.
     * 
     * @param id
     *            An <code>int</code>.
     */
    private native boolean terminate(int id);
}
