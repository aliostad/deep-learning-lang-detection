package models.spa.example;

import models.spa.api.ProcessInstance;
import models.spa.api.ProcessModel;


public class MailProcess_Repo_Interaction
{

    public static void main(String[] args) throws Exception
    {
        // load from file
        ProcessModel pm = ProcessModel.loadProcessModel("files/mail_process.ttl");
        ProcessInstance pi = ProcessInstance.loadProcessInstance("files/mail_process_instance.ttl");

        // store in repository
        pm.delete();
        pm.store();

        pi.delete();
        pi.store();

        // load from repository and save to file
        ProcessModel.getProcess(pm.getId()).saveModelToFile("files/mail_process_2.ttl");
        ProcessInstance.getProcessInstance(null, pi.getId()).saveInstanceToFile("files/mail_process_instance_2.ttl");
    }
}
