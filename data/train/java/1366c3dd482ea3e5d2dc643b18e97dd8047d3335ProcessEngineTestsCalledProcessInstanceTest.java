package org.activiti.testing.assertions;

import static org.activiti.testing.assertions.ProcessEngineAssertions.assertThat;
import static org.activiti.testing.assertions.ProcessEngineTests.calledProcessInstance;
import static org.activiti.testing.assertions.ProcessEngineTests.complete;
import static org.activiti.testing.assertions.ProcessEngineTests.processInstanceQuery;
import static org.activiti.testing.assertions.ProcessEngineTests.runtimeService;
import static org.activiti.testing.assertions.ProcessEngineTests.task;

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
public class ProcessEngineTestsCalledProcessInstanceTest extends ProcessAssertTestCase {

  @Rule
  public ActivitiRule processEngineRule = new ActivitiRule();

  @Test
  @Deployment(resources = {"ProcessEngineTests-calledProcessInstance-superProcess1.bpmn",
    "ProcessEngineTests-calledProcessInstance-subProcess1.bpmn",
    "ProcessEngineTests-calledProcessInstance-subProcess2.bpmn"
  })
  public void testCalledProcessInstance_FirstOfTwoSequential_Success() {
    // Given
    final ProcessInstance processInstance = runtimeService().startProcessInstanceByKey(
      "ProcessEngineTests-calledProcessInstance-superProcess1"
    );
    // When
    assertThat(processInstance)
      .hasProcessDefinitionKey("ProcessEngineTests-calledProcessInstance-superProcess1");
    // Then
    assertThat(calledProcessInstance())
      .hasProcessDefinitionKey("ProcessEngineTests-calledProcessInstance-subProcess1");
    // And
    assertThat(calledProcessInstance(processInstance))
      .hasProcessDefinitionKey("ProcessEngineTests-calledProcessInstance-subProcess1");
    // When
    assertThat(processInstance)
      .hasProcessDefinitionKey("ProcessEngineTests-calledProcessInstance-superProcess1");
    // And
    assertThat(calledProcessInstance("ProcessEngineTests-calledProcessInstance-subProcess1"))
      .hasProcessDefinitionKey("ProcessEngineTests-calledProcessInstance-subProcess1");
    // And
    assertThat(calledProcessInstance("ProcessEngineTests-calledProcessInstance-subProcess1", processInstance))
      .hasProcessDefinitionKey("ProcessEngineTests-calledProcessInstance-subProcess1");
    // When
    assertThat(processInstance)
      .hasProcessDefinitionKey("ProcessEngineTests-calledProcessInstance-superProcess1");
    // And
    assertThat(calledProcessInstance(processInstanceQuery().processDefinitionKey("ProcessEngineTests-calledProcessInstance-subProcess1")))
      .hasProcessDefinitionKey("ProcessEngineTests-calledProcessInstance-subProcess1");
    // And
    assertThat(calledProcessInstance(processInstanceQuery().processDefinitionKey("ProcessEngineTests-calledProcessInstance-subProcess1"), processInstance))
      .hasProcessDefinitionKey("ProcessEngineTests-calledProcessInstance-subProcess1");
  }

  @Test
  @Deployment(resources = {"ProcessEngineTests-calledProcessInstance-superProcess1.bpmn",
    "ProcessEngineTests-calledProcessInstance-subProcess1.bpmn",
    "ProcessEngineTests-calledProcessInstance-subProcess2.bpmn"
  })
  public void testCalledProcessInstance_SecondOfTwoSequential_Success() {
    // Given
    final ProcessInstance processInstance = runtimeService().startProcessInstanceByKey(
      "ProcessEngineTests-calledProcessInstance-superProcess1"
    );
    // And
    complete(task("UserTask_1", calledProcessInstance(processInstance)));
    // When
    assertThat(processInstance)
      .hasProcessDefinitionKey("ProcessEngineTests-calledProcessInstance-superProcess1");
    // Then
    assertThat(calledProcessInstance())
      .hasProcessDefinitionKey("ProcessEngineTests-calledProcessInstance-subProcess2");
    // And
    assertThat(calledProcessInstance(processInstance))
      .hasProcessDefinitionKey("ProcessEngineTests-calledProcessInstance-subProcess2");
    // When
    assertThat(processInstance)
      .hasProcessDefinitionKey("ProcessEngineTests-calledProcessInstance-superProcess1");
    // And
    assertThat(calledProcessInstance("ProcessEngineTests-calledProcessInstance-subProcess2"))
      .hasProcessDefinitionKey("ProcessEngineTests-calledProcessInstance-subProcess2");
    // And
    assertThat(calledProcessInstance("ProcessEngineTests-calledProcessInstance-subProcess2", processInstance))
      .hasProcessDefinitionKey("ProcessEngineTests-calledProcessInstance-subProcess2");
    // When
    assertThat(processInstance)
      .hasProcessDefinitionKey("ProcessEngineTests-calledProcessInstance-superProcess1");
    // And
    assertThat(calledProcessInstance(processInstanceQuery().processDefinitionKey("ProcessEngineTests-calledProcessInstance-subProcess2")))
      .hasProcessDefinitionKey("ProcessEngineTests-calledProcessInstance-subProcess2");
    // And
    assertThat(calledProcessInstance(processInstanceQuery().processDefinitionKey("ProcessEngineTests-calledProcessInstance-subProcess2"), processInstance))
      .hasProcessDefinitionKey("ProcessEngineTests-calledProcessInstance-subProcess2");
  }

  @Test
  @Deployment(resources = {"ProcessEngineTests-calledProcessInstance-superProcess1.bpmn",
    "ProcessEngineTests-calledProcessInstance-subProcess1.bpmn",
    "ProcessEngineTests-calledProcessInstance-subProcess2.bpmn"
  })
  public void testCalledProcessInstance_SecondOfTwoSequential_Failure() {
    // Given
    final ProcessInstance processInstance = runtimeService().startProcessInstanceByKey(
      "ProcessEngineTests-calledProcessInstance-superProcess1"
    );
    // And
    complete(task("UserTask_1", calledProcessInstance(processInstance)));
    // Then
    expect(new Failure() {
      @Override
      public void when() {
        assertThat(calledProcessInstance())
          .isNotNull();
      }
    });
    // And
    expect(new Failure() {
      @Override
      public void when() {
        assertThat(calledProcessInstance("ProcessEngineTests-calledProcessInstance-subProcess2"))
          .isNotNull();
      }
    });
    // And
    expect(new Failure() {
      @Override
      public void when() {
        assertThat(calledProcessInstance(processInstanceQuery().processDefinitionKey("ProcessEngineTests-calledProcessInstance-subProcess2")))
          .isNotNull();
      }
    });
    // When
    assertThat(processInstance)
      .hasProcessDefinitionKey("ProcessEngineTests-calledProcessInstance-superProcess1");
    // Then
    expect(new Failure() {
      @Override
      public void when() {
        assertThat(calledProcessInstance())
          .isNull();
      }
    });
    // And
    expect(new Failure() {
      @Override
      public void when() {
        assertThat(calledProcessInstance("ProcessEngineTests-calledProcessInstance-subProcess1"))
          .isNotNull();
      }
    });
    // And
    expect(new Failure() {
      @Override
      public void when() {
        assertThat(calledProcessInstance(processInstanceQuery().processDefinitionKey("ProcessEngineTests-calledProcessInstance-subProcess1")))
          .isNotNull();
      }
    });
  }

  @Test
  @Deployment(resources = {"ProcessEngineTests-calledProcessInstance-superProcess2.bpmn",
    "ProcessEngineTests-calledProcessInstance-subProcess1.bpmn",
    "ProcessEngineTests-calledProcessInstance-subProcess2.bpmn"
  })
  public void testCalledProcessInstance_TwoOfTwoParallel_Success() {
    // When
    final ProcessInstance processInstance = runtimeService().startProcessInstanceByKey(
      "ProcessEngineTests-calledProcessInstance-superProcess2"
    );
    // Then
    assertThat(calledProcessInstance("ProcessEngineTests-calledProcessInstance-subProcess1", processInstance))
      .hasProcessDefinitionKey("ProcessEngineTests-calledProcessInstance-subProcess1");
    // And
    assertThat(calledProcessInstance(processInstanceQuery().processDefinitionKey("ProcessEngineTests-calledProcessInstance-subProcess1"), processInstance))
      .hasProcessDefinitionKey("ProcessEngineTests-calledProcessInstance-subProcess1");
    // And
    assertThat(calledProcessInstance("ProcessEngineTests-calledProcessInstance-subProcess2", processInstance))
      .hasProcessDefinitionKey("ProcessEngineTests-calledProcessInstance-subProcess2");
    // And
    assertThat(calledProcessInstance(processInstanceQuery().processDefinitionKey("ProcessEngineTests-calledProcessInstance-subProcess2"), processInstance))
      .hasProcessDefinitionKey("ProcessEngineTests-calledProcessInstance-subProcess2");
  }

  @Test
  @Deployment(resources = {"ProcessEngineTests-calledProcessInstance-superProcess2.bpmn",
    "ProcessEngineTests-calledProcessInstance-subProcess1.bpmn",
    "ProcessEngineTests-calledProcessInstance-subProcess2.bpmn"
  })
  public void testCalledProcessInstance_TwoOfTwoParallel_Failure() {
    // When
    final ProcessInstance processInstance = runtimeService().startProcessInstanceByKey(
      "ProcessEngineTests-calledProcessInstance-superProcess2"
    );
    // Then
    expect(new Failure() {
      @Override
      public void when() {
        assertThat(calledProcessInstance("ProcessEngineTests-calledProcessInstance-subProcess3", processInstance))
          .isNotNull();
      }
    });
  }

}
