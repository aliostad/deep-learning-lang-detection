package org.fkjava.activiti.test.action;

import java.io.File;
import java.io.InputStream;
import java.util.List;

import javax.annotation.Resource;

import org.activiti.engine.repository.ProcessDefinition;
import org.fkjava.activiti.test.service.ProcessService;

import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionSupport;

/**
 * 流程定义Action负责处理流程定义相关的操作，包括：部署流程、查询部署的流程、删除流程等。
 * 
 * @author lwq
 */
public class ProcessDefinitionAction extends ActionSupport {

    /**
	 * 
	 */
    private static final long serialVersionUID = 1L;
    @Resource
    private ProcessService processService;
    private File uploadProcessDefinition;
    private String processDefinitionId;

    public String deploy() {
        processService.deploy(uploadProcessDefinition);
        return SUCCESS;
    }

    /**
     * 查询所有已经部署的流程列表
     * 
     * @return
     */
    public String list() {
        List<ProcessDefinition> processDefinitionList = processService
                .getProcessDefinitionList();
        ActionContext.getContext().put("processDefinitionList",
                processDefinitionList);
        return SUCCESS;
    }

    public String view() {
        // 根据流程定义ID查询流程定义
        ProcessDefinition processDefinition = processService
                .getProcessDefinition(processDefinitionId);
        ActionContext.getContext().put("processDefinition", processDefinition);
        return SUCCESS;
    }

    /**
     * 禁用流程定义
     * 
     * @return
     */
    public String disable() {
        processService.disableProcessDefinition(processDefinitionId);
        return SUCCESS;
    }

    /**
     * 激活流程定义
     * 
     * @return
     */
    public String activity() {
        processService.activityProcessDefinition(processDefinitionId);
        return SUCCESS;
    }

    /**
     * 获取流程定义图片
     * 
     * @return
     * @throws Exception
     */
    public InputStream getProcessDefinitionImage() {
        // 获取流程图
        InputStream inputStream = processService.getProcessDefinitionImage(
                processDefinitionId).getImage();
        return inputStream;
    }

    /**
     * @return the processDefinitionId
     */
    public String getProcessDefinitionId() {
        return processDefinitionId;
    }

    /**
     * @param processDefinitionId
     *            the processDefinitionId to set
     */
    public void setProcessDefinitionId(String processDefinitionId) {
        this.processDefinitionId = processDefinitionId;
    }

    /**
     * @return the uploadProcessDefinition
     */
    public File getUploadProcessDefinition() {
        return uploadProcessDefinition;
    }

    /**
     * @param uploadProcessDefinition
     *            the uploadProcessDefinition to set
     */
    public void setUploadProcessDefinition(File uploadProcessDefinition) {
        this.uploadProcessDefinition = uploadProcessDefinition;
    }
}
