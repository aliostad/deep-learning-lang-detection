package com.tianyi.bph.domain.system;

public class ServiceSet {
    private Integer serviceId;

    private String serviceName;

    private Integer serviceType;
    
    public String getServiceTypeName() {
    	if(serviceType.intValue()==1){
			this.serviceTypeName="MQ服务";
		}else if(serviceType.intValue()==2){
			this.serviceTypeName="天网接入";
		}else{
			this.serviceTypeName="GPS服务";
		}
		return serviceTypeName;
	}

	public void setServiceTypeName(String serviceTypeName) {
		this.serviceTypeName=serviceTypeName;
	}

	private String serviceTypeName;

    private String serviceIp;

    private Integer servicePort;

    private String serviceAccount;

    private String servicePwd;

    private String serviceVersion;

    private String exchangeName;

    public Integer getServiceId() {
        return serviceId;
    }

    public void setServiceId(Integer serviceId) {
        this.serviceId = serviceId;
    }

    public String getServiceName() {
        return serviceName;
    }

    public void setServiceName(String serviceName) {
        this.serviceName = serviceName;
    }

    public Integer getServiceType() {
        return serviceType;
    }

    public void setServiceType(Integer serviceType) {
        this.serviceType = serviceType;
    }

    public String getServiceIp() {
        return serviceIp;
    }

    public void setServiceIp(String serviceIp) {
        this.serviceIp = serviceIp;
    }

    public Integer getServicePort() {
        return servicePort;
    }

    public void setServicePort(Integer servicePort) {
        this.servicePort = servicePort;
    }

    public String getServiceAccount() {
        return serviceAccount;
    }

    public void setServiceAccount(String serviceAccount) {
        this.serviceAccount = serviceAccount;
    }

    public String getServicePwd() {
        return servicePwd;
    }

    public void setServicePwd(String servicePwd) {
        this.servicePwd = servicePwd;
    }

    public String getServiceVersion() {
        return serviceVersion;
    }

    public void setServiceVersion(String serviceVersion) {
        this.serviceVersion = serviceVersion;
    }

    public String getExchangeName() {
        return exchangeName;
    }

    public void setExchangeName(String exchangeName) {
        this.exchangeName = exchangeName;
    }
}