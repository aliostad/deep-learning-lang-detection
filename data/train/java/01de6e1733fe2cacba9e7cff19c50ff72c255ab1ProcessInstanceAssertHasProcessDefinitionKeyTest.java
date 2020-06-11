package org.activiti.testing.assertions;

import static org.activiti.testing.assertions.ProcessEngineAssertions.assertThat;
import static org.activiti.testing.assertions.ProcessEngineTests.runtimeService;

import org.activiti.engine.runtime.ProcessInstance;
import org.activiti.engine.test.ActivitiRule;
import org.activiti.engine.test.Deployment;
import org.activiti.testing.assertions.helpers.Failure;
import org.activiti.testing.assertions.helpers.ProcessAssertTestCase;
import org.junit.Rule;
import org.junit.Test;

/**
 * @author Martin Schimak <martin.schimak@plexiti.com>
 */
public class ProcessInstanceAssertHasProcessDefinitionKeyTest extends ProcessAssertTestCase {

  @Rule
  public ActivitiRule processEngineRule = new ActivitiRule();

  @Test
  @Deployment(resources = {
    "ProcessInstanceAssert-hasProcessDefinitionKey-1.bpmn",
    "ProcessInstanceAssert-hasProcessDefinitionKey-2.bpmn"
  })
  public void testHasProcessDefinitionKey_Success() {
    // When
    ProcessInstance processInstance = runtimeService().startProcessInstanceByKey(
      "ProcessInstanceAssert-hasProcessDefinitionKey-1"
    );
    // Then
    assertThat(processInstance).hasProcessDefinitionKey("ProcessInstanceAssert-hasProcessDefinitionKey-1");
  }

  @Test
  @Deployment(resources = {
    "ProcessInstanceAssert-hasProcessDefinitionKey-1.bpmn",
    "ProcessInstanceAssert-hasProcessDefinitionKey-2.bpmn"
  })
  public void testHasProcessDefinitionKey_Failure() {
    // Given
    final ProcessInstance processInstance = runtimeService().startProcessInstanceByKey(
      "ProcessInstanceAssert-hasProcessDefinitionKey-2"
    );
    // When
    runtimeService().suspendProcessInstanceById(processInstance.getId());
    // Then
    expect(new Failure() {
      @Override
      public void when() {
        assertThat(processInstance).hasProcessDefinitionKey("ProcessInstanceAssert-hasProcessDefinitionKey-1");
      }
    });
  }

}
