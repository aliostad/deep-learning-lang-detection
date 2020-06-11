/*
 * Licensed to the Sakai Foundation (SF) under one
 * or more contributor license agreements. See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership. The SF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License. You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied. See the License for the
 * specific language governing permissions and limitations under the License.
 */

package org.sakaiproject.nakamura.workflow.persistence.managers;

import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.Map;

import javax.jcr.Session;

import org.drools.WorkingMemory;
import org.drools.common.InternalRuleBase;
import org.drools.common.InternalWorkingMemory;
import org.drools.process.core.Process;
import org.drools.process.instance.ProcessInstance;
import org.drools.process.instance.ProcessInstanceManager;
import org.drools.process.instance.impl.ProcessInstanceImpl;
import org.sakaiproject.nakamura.api.workflow.WorkflowConstants;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class JcrProcessInstanceManager implements ProcessInstanceManager {

  private static final Logger LOGGER = LoggerFactory
      .getLogger(JcrProcessInstanceManager.class);
  private WorkingMemory workingMemory;
  private transient Map<Long, ProcessInstance> processInstances;
  private Session session;

  /**
   * 
   */
  public JcrProcessInstanceManager(WorkingMemory workingMemory) {
    this.workingMemory = workingMemory;
    session = (Session) this.workingMemory.getEnvironment().get(
        WorkflowConstants.SESSION_IDENTIFIER);

  }

  public void addProcessInstance(ProcessInstance processInstance) {
    try {
      ProcessInstanceInfo processInstanceInfo = new ProcessInstanceInfo(session,
          processInstance);
      processInstanceInfo.save();
      processInstance = (ProcessInstance) processInstanceInfo
          .getProcessInstance(workingMemory);
      processInstanceInfo.getProcessInstance(workingMemory);
      processInstanceInfo.updateLastReadDate();
      internalAddProcessInstance(processInstance);
    } catch (Exception e) {
      LOGGER.info("failed to add process instance " + processInstance, e);
      throw new RuntimeException("failed to add process instance " + processInstance, e);
    }
  }

  public void internalAddProcessInstance(ProcessInstance processInstance) {
    if (this.processInstances == null) {
      this.processInstances = new HashMap<Long, ProcessInstance>();
    }
    processInstances.put(processInstance.getId(), processInstance);
  }

  public ProcessInstance getProcessInstance(long id) {
    ProcessInstance processInstance = null;
    if (this.processInstances != null) {
      processInstance = this.processInstances.get(id);
      if (processInstance != null) {
        return processInstance;
      }
    }

    try {
      ProcessInstanceInfo processInstanceInfo = new ProcessInstanceInfo(session, id);
      processInstanceInfo.updateLastReadDate();
      processInstance = (ProcessInstance) processInstanceInfo
          .getProcessInstance(workingMemory);
      Process process = ((InternalRuleBase) workingMemory.getRuleBase())
          .getProcess(processInstance.getProcessId());
      if (process == null) {
        throw new IllegalArgumentException("Could not find process "
            + processInstance.getProcessId());
      }
      processInstance.setProcess(process);
      if (processInstance.getWorkingMemory() == null) {
        processInstance.setWorkingMemory((InternalWorkingMemory) workingMemory);
        ((ProcessInstanceImpl) processInstance).reconnect();
      }
      return processInstance;
    } catch (Exception e) {
      LOGGER.info("Could Not find process " + id, e);
      throw new IllegalArgumentException("Could Not find process " + id, e);
    }
  }

  public Collection<ProcessInstance> getProcessInstances() {
    return new ArrayList<ProcessInstance>();
  }

  public void removeProcessInstance(ProcessInstance processInstance) {
    try {
      ProcessInstanceInfo processInstanceInfo = new ProcessInstanceInfo(session,
          processInstance);
      processInstanceInfo.remove();
      internalRemoveProcessInstance(processInstance);
    } catch (Exception e) {
      LOGGER.info("Could Not remove process " + processInstance, e);
      throw new IllegalArgumentException("Could Not remove process " + processInstance, e);
    }
  }

  public void internalRemoveProcessInstance(ProcessInstance processInstance) {
    if (this.processInstances != null) {
      processInstances.remove(processInstance.getId());
    }
  }

  public void clearProcessInstances() {
    if (processInstances != null) {
      processInstances.clear();
    }
  }

}
