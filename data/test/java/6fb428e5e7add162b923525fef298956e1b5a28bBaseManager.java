/**
 * Copyright (c) 2009 eXtensible Catalog Organization
 *
 * This program is free software; you can redistribute it and/or modify it under the terms of the MIT/X11 license. The text of the
 * license can be found at http://www.opensource.org/licenses/mit-license.php and copy of the license can be found on the project
 * website http://www.extensiblecatalog.org/.
 *
 */

package xc.mst.manager;

import xc.mst.email.Emailer;
import xc.mst.harvester.HttpService;
import xc.mst.harvester.ValidateRepository;
import xc.mst.manager.configuration.EmailConfigService;
import xc.mst.manager.harvest.ScheduleService;
import xc.mst.manager.logs.LogService;
import xc.mst.manager.processingDirective.JobService;
import xc.mst.manager.processingDirective.ProcessingDirectiveService;
import xc.mst.manager.processingDirective.ServicesService;
import xc.mst.manager.record.BrowseRecordService;
import xc.mst.manager.record.ExpressionService;
import xc.mst.manager.record.HoldingsService;
import xc.mst.manager.record.ItemService;
import xc.mst.manager.record.MSTSolrService;
import xc.mst.manager.record.ManifestationService;
import xc.mst.manager.record.MessageService;
import xc.mst.manager.record.RecordService;
import xc.mst.manager.record.WorkService;
import xc.mst.manager.repository.FormatService;
import xc.mst.manager.repository.ProviderService;
import xc.mst.manager.repository.SetService;
import xc.mst.manager.user.GroupService;
import xc.mst.manager.user.PermissionService;
import xc.mst.manager.user.ServerService;
import xc.mst.manager.user.UserGroupUtilService;
import xc.mst.manager.user.UserService;
import xc.mst.repo.RepositoryService;
import xc.mst.utils.index.SolrIndexManager;

public class BaseManager extends BaseService {

    protected EmailConfigService emailConfigService = null;
    protected ScheduleService scheduleService = null;
    protected LogService logService = null;
    protected JobService jobService = null;
    protected ProcessingDirectiveService processingDirectiveService = null;
    protected ServicesService servicesService = null;
    protected BrowseRecordService browseRecordService = null;
    protected ExpressionService expressionService = null;
    protected HoldingsService holdingsService = null;
    protected ItemService itemService = null;
    protected ManifestationService manifestationService = null;
    protected WorkService workService = null;
    protected FormatService formatService = null;
    protected ProviderService providerService = null;
    protected SetService setService = null;
    protected GroupService groupService = null;
    protected PermissionService permissionService = null;
    protected ServerService serverService = null;
    protected UserGroupUtilService userGroupUtilService = null;
    protected UserService userService = null;
    protected RecordService recordService = null;
    protected ValidateRepository validateRepository = null;
    protected MSTSolrService MSTSolrService = null;
    protected HttpService httpService = null;
    protected RepositoryService repositoryService = null;
    protected MessageService messageService = null;
    protected Emailer emailer = null;

    public EmailConfigService getEmailConfigService() {
        return emailConfigService;
    }

    public void setEmailConfigService(EmailConfigService emailConfigService) {
        this.emailConfigService = emailConfigService;
    }

    public ScheduleService getScheduleService() {
        return scheduleService;
    }

    public void setScheduleService(ScheduleService scheduleService) {
        this.scheduleService = scheduleService;
    }

    public LogService getLogService() {
        return logService;
    }

    public void setLogService(LogService logService) {
        this.logService = logService;
    }

    public JobService getJobService() {
        return jobService;
    }

    public void setJobService(JobService jobService) {
        this.jobService = jobService;
    }

    public ProcessingDirectiveService getProcessingDirectiveService() {
        return processingDirectiveService;
    }

    public void setProcessingDirectiveService(
            ProcessingDirectiveService processingDirectiveService) {
        this.processingDirectiveService = processingDirectiveService;
    }

    public ServicesService getServicesService() {
        return servicesService;
    }

    public void setServicesService(ServicesService servicesService) {
        this.servicesService = servicesService;
    }

    public BrowseRecordService getBrowseRecordService() {
        return browseRecordService;
    }

    public void setBrowseRecordService(BrowseRecordService browseRecordService) {
        this.browseRecordService = browseRecordService;
    }

    public ExpressionService getExpressionService() {
        return expressionService;
    }

    public void setExpressionService(ExpressionService expressionService) {
        this.expressionService = expressionService;
    }

    public HoldingsService getHoldingsService() {
        return holdingsService;
    }

    public void setHoldingsService(HoldingsService holdingsService) {
        this.holdingsService = holdingsService;
    }

    public ItemService getItemService() {
        return itemService;
    }

    public void setItemService(ItemService itemService) {
        this.itemService = itemService;
    }

    public ManifestationService getManifestationService() {
        return manifestationService;
    }

    public void setManifestationService(ManifestationService manifestationService) {
        this.manifestationService = manifestationService;
    }

    public WorkService getWorkService() {
        return workService;
    }

    public void setWorkService(WorkService workService) {
        this.workService = workService;
    }

    public FormatService getFormatService() {
        return formatService;
    }

    public void setFormatService(FormatService formatService) {
        this.formatService = formatService;
    }

    public ProviderService getProviderService() {
        return providerService;
    }

    public void setProviderService(ProviderService providerService) {
        this.providerService = providerService;
    }

    public SetService getSetService() {
        return setService;
    }

    public void setSetService(SetService setService) {
        this.setService = setService;
    }

    public GroupService getGroupService() {
        return groupService;
    }

    public void setGroupService(GroupService groupService) {
        this.groupService = groupService;
    }

    public PermissionService getPermissionService() {
        return permissionService;
    }

    public void setPermissionService(PermissionService permissionService) {
        this.permissionService = permissionService;
    }

    public ServerService getServerService() {
        return serverService;
    }

    public void setServerService(ServerService serverService) {
        this.serverService = serverService;
    }

    public UserGroupUtilService getUserGroupUtilService() {
        return userGroupUtilService;
    }

    public void setUserGroupUtilService(UserGroupUtilService userGroupUtilService) {
        this.userGroupUtilService = userGroupUtilService;
    }

    public UserService getUserService() {
        return userService;
    }

    public void setUserService(UserService userService) {
        this.userService = userService;
    }

    public RecordService getRecordService() {
        return recordService;
    }

    public void setRecordService(RecordService recordService) {
        this.recordService = recordService;
    }

    public ValidateRepository getValidateRepository() {
        return validateRepository;
    }

    public void setValidateRepository(ValidateRepository validateRepository) {
        this.validateRepository = validateRepository;
    }

    public MSTSolrService getMSTSolrService() {
        return MSTSolrService;
    }

    public void setMSTSolrService(MSTSolrService MSTSolrService) {
        this.MSTSolrService = MSTSolrService;
    }

    public SolrIndexManager getSolrIndexManager() {
        return (SolrIndexManager) config.getBean("SolrIndexManager");
    }

    public HttpService getHttpService() {
        return httpService;
    }

    public void setHttpService(HttpService httpService) {
        this.httpService = httpService;
    }

    public RepositoryService getRepositoryService() {
        return repositoryService;
    }

    public void setRepositoryService(RepositoryService repositoryService) {
        this.repositoryService = repositoryService;
    }

    public MessageService getMessageService() {
        return messageService;
    }

    public void setMessageService(MessageService messageService) {
        this.messageService = messageService;
    }

    public Emailer getEmailer() {
        return emailer;
    }

    public void setEmailer(Emailer emailer) {
        this.emailer = emailer;
    }
}
