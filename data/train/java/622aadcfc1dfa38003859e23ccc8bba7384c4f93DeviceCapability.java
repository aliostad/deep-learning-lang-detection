package com.taixin.android.onvif.sdk.obj;

public class DeviceCapability {
	private String analytics;
	private String deviceService;
	private String eventsService;
	private String imagingService;
	private String mediaService;
	private String ptzService;
	
	public DeviceCapability(){
		
	}
	public String getAnalytics() {
		return analytics;
	}
	public void setAnalytics(String analytics) {
		this.analytics = analytics;
	}
	public String getDeviceService() {
		return deviceService;
	}
	public void setDeviceService(String deviceService) {
		this.deviceService = deviceService;
	}
	public String getEventsService() {
		return eventsService;
	}
	public void setEventsService(String eventsService) {
		this.eventsService = eventsService;
	}
	public String getImagingService() {
		return imagingService;
	}
	public void setImagingService(String imagingService) {
		this.imagingService = imagingService;
	}
	public String getMediaService() {
		return mediaService;
	}
	public void setMediaService(String mediaService) {
		this.mediaService = mediaService;
	}
	public String getPtzService() {
		return ptzService;
	}
	public void setPtzService(String ptzService) {
		this.ptzService = ptzService;
	}

}
