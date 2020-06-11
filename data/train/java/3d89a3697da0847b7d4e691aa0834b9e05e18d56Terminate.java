/*
 * Created On:  Nov 19, 2007 9:20:48 AM
 */
package com.thinkparity.ophelia.support.ui.action.application.process;

import java.io.File;
import java.util.ArrayList;
import java.util.List;

import com.thinkparity.bootstrap.Constants;
import com.thinkparity.ophelia.support.ui.Input;
import com.thinkparity.ophelia.support.ui.action.AbstractAction;
import com.thinkparity.ophelia.support.util.process.ProcessException;
import com.thinkparity.ophelia.support.util.process.ProcessInfo;
import com.thinkparity.ophelia.support.util.process.ProcessUtil;
import com.thinkparity.ophelia.support.util.process.ProcessUtilProvider;

/**
 * <b>Title:</b>thinkParity Ophelia Support UI Profile Delete Action<br>
 * <b>Description:</b><br>
 * 
 * @author raymond@thinkparity.com
 * @version 1.1.2.1
 */
public final class Terminate extends AbstractAction {

    /**
     * Determine if the process is the executable.
     * 
     * @param process
     *            A <code>ProcessInfo</code>.
     * @return True if the process is the thinkParity executable.
     */
    private static boolean isExecutable(final ProcessInfo process) {
        final File executable = new File(System.getProperty(
                Constants.PropertyNames.ThinkParity.Executable));
        return process.getFile().equals(executable.getName());
    }

    /**
     * Determine if the process is the image executable.
     * 
     * @param process
     *            A <code>ProcessInfo</code>.
     * @return True if the process is the image executable.
     */
    private static boolean isImageExecutable(final ProcessInfo process) {
        final File imageExecutable = new File(System.getProperty(
                Constants.PropertyNames.ThinkParity.ImageExecutable));
        return process.getFile().equals(imageExecutable.getName());
    }

    /**
     * Determine if the parent process is the thinkParity executable.
     * 
     * @param process
     *            A <code>ProcessInfo</code>.
     * @param processList
     *            A <code>List<ProcessInfo></code>.
     * @return True if the parent process is the thinkParity executable.
     */
    private static boolean isParentExecutable(final ProcessInfo process,
            final List<ProcessInfo> processList) {
        ProcessInfo parent = null;
        for (final ProcessInfo p : processList) {
            if (p.getId().equals(process.getParentId())) {
                parent = p;
                break;
            }
        }
        return null == parent ? false : isExecutable(parent);
    }

    /**
     * Determine if the parent process is non existent.
     * 
     * @param process
     *            A <code>ProcessInfo</code>.
     * @param processList
     *            A <code>List<ProcessInfo></code>.
     * @return True if the parent process is non existent.
     */
    private static boolean isParentNull(final ProcessInfo process,
            final List<ProcessInfo> processList) {
        ProcessInfo parent = null;
        for (final ProcessInfo p : processList) {
            if (p.getId().equals(process.getParentId())) {
                parent = p;
                break;
            }
        }
        return null == parent ? true : false;
    }

    /**
     * Determine if the process is a target for termination.
     * 
     * @param process
     *            A <code>ProcessInfo</code>.
     * @param processList
     *            A <code>List<ProcessInfo></code>.
     * @return True if the process is the thinkParity executable or if it is a
     *         child of a thinkParity executable.
     */
    private static boolean isTarget(final ProcessInfo process,
            final List<ProcessInfo> processList) {
        if (isExecutable(process)) {
            return true;
        } else {
            if (isParentExecutable(process, processList)) {
                return true;
            } else {
                if (isImageExecutable(process) && isParentNull(process, processList)) {
                    return true;
                } else {
                    return false;
                }
            }
        }
    }

    /**
     * Create Kill.
     *
     */
    public Terminate() {
        super("/application/process/terminate");
    }

    /**
     * @see com.thinkparity.ophelia.support.ui.action.Action#invoke(com.thinkparity.ophelia.support.ui.action.Input)
     *
     */
    @Override
    public void invoke(final Input input) {
        final ProcessUtil processUtil = getProcessUtil();
        try {
            final List<ProcessInfo> processList = processUtil.getProcessList();
            final List<ProcessInfo> targetProcessList = new ArrayList<ProcessInfo>(processList.size());
            for (final ProcessInfo process : processList) {
                if (isTarget(process, processList)) {
                    targetProcessList.add(process);
                }
            }
            for (final ProcessInfo process: targetProcessList) {
                try {
                    logger.logInfo("Terminating {0}.", process.getId());
                    processUtil.terminate(process.getId());
                } catch (final ProcessException px) {
                    logger.logError(px, "Could not terminated process {0}.",
                            process);
                }
            }
        } catch (final ProcessException px) {
            logger.logError(px, "Could not terminated process.");
        }
    }

    /**
     * Obtain an instance of a process utility.
     * 
     * @return A <code>ProcessUtil</code>.
     */
    private ProcessUtil getProcessUtil() {
        return ProcessUtilProvider.getInstance().getProcessUtil();
    }
}
