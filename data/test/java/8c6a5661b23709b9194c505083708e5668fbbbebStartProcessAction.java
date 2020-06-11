package uk.co.markberridge.struts;


public class StartProcessAction extends BaseProcessAction {

    private String processDefinitionKey;

    @Override
    public String execute() throws Exception {
        getProcessService().startProcessByKey(getProcessDefinitionKey(), getProcessVariables());
        return SUCCESS;
    }

    public String getProcessDefinitionKey() {
        return processDefinitionKey;
    }

    public void setProcessDefinitionKey(String processDefinitionKey) {
        this.processDefinitionKey = processDefinitionKey;
    }
}
