package com.lorent.service.impl;

import java.io.Serializable;

import com.lorent.service.AuthorityService;
import com.lorent.service.BillingService;
import com.lorent.service.ConfRoleAuthorityService;
import com.lorent.service.ConfUserAuthorityService;
import com.lorent.service.ConfUserRoleService;
import com.lorent.service.ConferenceNewService;
import com.lorent.service.ConferenceNoService;
import com.lorent.service.ConferenceRoleService;
import com.lorent.service.ConferenceService;
import com.lorent.service.ConferenceTypeRoleService;
import com.lorent.service.ConferenceTypeService;
import com.lorent.service.ConferenceUserService;
import com.lorent.service.CronConferenceService;
import com.lorent.service.CustomerService;
import com.lorent.service.DepartmentService;
import com.lorent.service.McuMixerService;
import com.lorent.service.McuServerService;
import com.lorent.service.MediaService;
import com.lorent.service.OperateRecordService;
import com.lorent.service.RatesService;
import com.lorent.service.RoleService;
import com.lorent.service.SipConfService;
import com.lorent.service.SysServerConfigService;
import com.lorent.service.UserService;
import com.lorent.service.VideoClipService;

public class ServiceFacade implements Serializable {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private RoleService roleService;
	private UserService userService;
	private McuServerService mcuServerService;
	private McuMixerService mcuMixerService;
	private CustomerService customerService;
	private StaticService staticService;
	private ConferenceService conferenceService;
	private OperateRecordService operateRecordService;
	private BillingService billingService;
	private RatesService ratesService;
	private DepartmentService departmentService;
	private CronConferenceService cronConferenceService;
	private ConferenceNoService conferenceNoService;
	private MediaService mediaService;
	private MonitorService monitorService;
	
	private SipConfService sipConfService;
	private ConferenceTypeService conferenceTypeService;
	private AuthorityService authorityService;
	private ConferenceRoleService conferenceRoleService;
	private ConfRoleAuthorityService confRoleAuthorityService;
	private ConferenceTypeRoleService conferenceTypeRoleService;
	private ConferenceNewService conferenceNewService;
	private ConferenceUserService conferenceUserService;
	private ConfUserRoleService confUserRoleService;
	private ConfUserAuthorityService confUserAuthorityService;

	private SysServerConfigService sysServerConfigService;
	
	private VideoClipService videoClipService;
	
	
	public VideoClipService getVideoClipService() {
		return videoClipService;
	}
	public void setVideoClipService(VideoClipService videoClipService) {
		this.videoClipService = videoClipService;
	}
	public SysServerConfigService getSysServerConfigService() {
		return sysServerConfigService;
	}
	public void setSysServerConfigService(
			SysServerConfigService sysServerConfigService) {
		this.sysServerConfigService = sysServerConfigService;
	}
	public SipConfService getSipConfService() {
		return sipConfService;
	}
	public void setSipConfService(SipConfService sipConfService) {
		this.sipConfService = sipConfService;
	}
	public static long getSerialVersionUID() {
		return serialVersionUID;
	}
	public MonitorService getMonitorService() {
		return monitorService;
	}
	public void setMonitorService(MonitorService monitorService) {
		this.monitorService = monitorService;
	}
	public ConferenceNoService getConferenceNoService() {
		return conferenceNoService;
	}
	public void setConferenceNoService(ConferenceNoService conferenceNoService) {
		this.conferenceNoService = conferenceNoService;
	}
	public OperateRecordService getOperateRecordService() {
		return operateRecordService;
	}
	public void setOperateRecordService(OperateRecordService operateRecordService) {
		this.operateRecordService = operateRecordService;
	}
	public RoleService getRoleService() {
		return roleService;
	}
	public void setRoleService(RoleService roleService) {
		this.roleService = roleService;
	}
	public UserService getUserService() {
		return userService;
	}
	public void setUserService(UserService userService) {
		this.userService = userService;
	}
	public McuServerService getMcuServerService() {
		return mcuServerService;
	}
	public void setMcuServerService(McuServerService mcuServerService) {
		this.mcuServerService = mcuServerService;
	}
	public McuMixerService getMcuMixerService() {
		return mcuMixerService;
	}
	public void setMcuMixerService(McuMixerService mcuMixerService) {
		this.mcuMixerService = mcuMixerService;
	}
	public CustomerService getCustomerService() {
		return customerService;
	}
	public void setCustomerService(CustomerService customerService) {
		this.customerService = customerService;
	}
	public StaticService getStaticService() {
		return staticService;
	}
	public void setStaticService(StaticService staticService) {
		this.staticService = staticService;
	}
	public ConferenceService getConferenceService() {
		return conferenceService;
	}
	public void setConferenceService(ConferenceService conferenceService) {
		this.conferenceService = conferenceService;
	}
	public BillingService getBillingService() {
		return billingService;
	}
	public void setBillingService(BillingService billingService) {
		this.billingService = billingService;
	}
	public RatesService getRatesService() {
		return ratesService;
	}
	public void setRatesService(RatesService ratesService) {
		this.ratesService = ratesService;
	}
	public DepartmentService getDepartmentService() {
		return departmentService;
	}
	public void setDepartmentService(DepartmentService departmentService) {
		this.departmentService = departmentService;
	}
	public CronConferenceService getCronConferenceService() {
		return cronConferenceService;
	}
	public void setCronConferenceService(CronConferenceService cronConferenceService) {
		this.cronConferenceService = cronConferenceService;
	}
	public MediaService getMediaService() {
		return mediaService;
	}
	public void setMediaService(MediaService mediaService) {
		this.mediaService = mediaService;
	}
	public ConferenceTypeService getConferenceTypeService() {
		return conferenceTypeService;
	}
	public void setConferenceTypeService(ConferenceTypeService conferenceTypeService) {
		this.conferenceTypeService = conferenceTypeService;
	}
	public AuthorityService getAuthorityService() {
		return authorityService;
	}
	public void setAuthorityService(AuthorityService authorityService) {
		this.authorityService = authorityService;
	}
	public ConferenceRoleService getConferenceRoleService() {
		return conferenceRoleService;
	}
	public void setConferenceRoleService(ConferenceRoleService conferenceRoleService) {
		this.conferenceRoleService = conferenceRoleService;
	}
	public ConfRoleAuthorityService getConfRoleAuthorityService() {
		return confRoleAuthorityService;
	}
	public void setConfRoleAuthorityService(
			ConfRoleAuthorityService confRoleAuthorityService) {
		this.confRoleAuthorityService = confRoleAuthorityService;
	}
	public ConferenceTypeRoleService getConferenceTypeRoleService() {
		return conferenceTypeRoleService;
	}
	public void setConferenceTypeRoleService(
			ConferenceTypeRoleService conferenceTypeRoleService) {
		this.conferenceTypeRoleService = conferenceTypeRoleService;
	}
	public ConferenceNewService getConferenceNewService() {
		return conferenceNewService;
	}
	public void setConferenceNewService(ConferenceNewService conferenceNewService) {
		this.conferenceNewService = conferenceNewService;
	}
	public ConferenceUserService getConferenceUserService() {
		return conferenceUserService;
	}
	public void setConferenceUserService(ConferenceUserService conferenceUserService) {
		this.conferenceUserService = conferenceUserService;
	}
	public ConfUserRoleService getConfUserRoleService() {
		return confUserRoleService;
	}
	public void setConfUserRoleService(ConfUserRoleService confUserRoleService) {
		this.confUserRoleService = confUserRoleService;
	}
	public ConfUserAuthorityService getConfUserAuthorityService() {
		return confUserAuthorityService;
	}
	public void setConfUserAuthorityService(
			ConfUserAuthorityService confUserAuthorityService) {
		this.confUserAuthorityService = confUserAuthorityService;
	}
}
