/*    */ package org.jeecgframework.workflow.model.activiti;
/*    */ 
/*    */ import java.util.Map;
/*    */ import javax.persistence.Transient;
/*    */ import org.activiti.engine.history.HistoricProcessInstance;
/*    */ import org.activiti.engine.repository.ProcessDefinition;
/*    */ import org.activiti.engine.runtime.ProcessInstance;
/*    */ import org.activiti.engine.task.Task;
/*    */ 
/*    */ public class Process
/*    */ {
/*    */   private Task task;
/*    */   private Map<String, Object> variables;
/*    */   private ProcessInstance processInstance;
/*    */   private HistoricProcessInstance historicProcessInstance;
/*    */   private ProcessDefinition processDefinition;
/*    */ 
/*    */   @Transient
/*    */   public Task getTask()
/*    */   {
/* 33 */     return this.task;
/*    */   }
/*    */ 
/*    */   public void setTask(Task task) {
/* 37 */     this.task = task;
/*    */   }
/*    */   @Transient
/*    */   public Map<String, Object> getVariables() {
/* 42 */     return this.variables;
/*    */   }
/*    */ 
/*    */   public void setVariables(Map<String, Object> variables) {
/* 46 */     this.variables = variables;
/*    */   }
/*    */   @Transient
/*    */   public ProcessInstance getProcessInstance() {
/* 51 */     return this.processInstance;
/*    */   }
/*    */ 
/*    */   public void setProcessInstance(ProcessInstance processInstance) {
/* 55 */     this.processInstance = processInstance;
/*    */   }
/*    */   @Transient
/*    */   public HistoricProcessInstance getHistoricProcessInstance() {
/* 60 */     return this.historicProcessInstance;
/*    */   }
/*    */ 
/*    */   public void setHistoricProcessInstance(HistoricProcessInstance historicProcessInstance)
/*    */   {
/* 65 */     this.historicProcessInstance = historicProcessInstance;
/*    */   }
/*    */   @Transient
/*    */   public ProcessDefinition getProcessDefinition() {
/* 70 */     return this.processDefinition;
/*    */   }
/*    */ 
/*    */   public void setProcessDefinition(ProcessDefinition processDefinition) {
/* 74 */     this.processDefinition = processDefinition;
/*    */   }
/*    */ }

/* Location:           C:\Users\tyy\Desktop\jeecgframework-core-v3.0.jar
 * Qualified Name:     org.jeecgframework.workflow.model.activiti.Process
 * JD-Core Version:    0.6.0
 */