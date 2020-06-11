/*******************************************************************************
 * Copyright (c) 2012 Arieh 'Vainolo' Bibliowicz
 * You can use this code for educational purposes. For any other uses
 * please contact me: vainolo@gmail.com
 *******************************************************************************/
package com.vainolo.phd.opm.interpreter;

import com.vainolo.phd.opm.interpreter.builtin.OPMAddProcessInstance;
import com.vainolo.phd.opm.interpreter.builtin.OPMAssignProcessInstance;
import com.vainolo.phd.opm.interpreter.builtin.OPMConceptualProcess;
import com.vainolo.phd.opm.interpreter.builtin.OPMInputProcessInstance;
import com.vainolo.phd.opm.interpreter.builtin.OPMOutputProcessInstance;
import com.vainolo.phd.opm.interpreter.builtin.OPMSleepProcessInstance;
import com.vainolo.phd.opm.model.OPMProcess;
import com.vainolo.phd.opm.model.OPMProcessKind;

public class OPMProcessInstanceFactory {
  public static OPMProcessInstance createProcessInstance(final OPMProcess process, final OPMProcessKind kind) {
    OPMProcessInstance processInstance;
    switch(kind) {
      case BUILT_IN:
        processInstance = createBuildInProcess(process);
        break;
      case COMPOUND:
        processInstance = new OPMCompoundProcessInstance(process);
        break;
      case CONCEPTUAL:
        processInstance = new OPMConceptualProcess(process);
        break;
      case JAVA:
        processInstance = new OPMJavaProcessInstance(process);
        break;
      default:
        throw new IllegalStateException("Received unexpected OPMProcessKind " + kind.getLiteral());
    }

    return processInstance;
  }

  private static OPMProcessInstance createBuildInProcess(final OPMProcess process) {
    OPMProcessInstance processInstance;

    if(process.getName().equals("Input")) {
      processInstance = new OPMInputProcessInstance(process);
    } else if(process.getName().equals("Output")) {
      processInstance = new OPMOutputProcessInstance(process);
    } else if(process.getName().equals("Add") || process.getName().equals("+")) {
      processInstance = new OPMAddProcessInstance(process);
    } else if(process.getName().equals("Sleep")) {
      processInstance = new OPMSleepProcessInstance(process);
    } else if(process.getName().equals("Assign") || process.getName().equals("=")) {
      processInstance = new OPMAssignProcessInstance(process);
    } else {
      throw new IllegalStateException("Tried to create unexistent build-in process " + process.getName());
    }

    return processInstance;

  }
}
