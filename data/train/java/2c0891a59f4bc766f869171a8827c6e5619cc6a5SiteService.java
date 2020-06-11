package net.shopxx.entity;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;

@Entity
@Table(name = "xx_service")
@SequenceGenerator(name = "sequenceGenerator", sequenceName = "xx_service_sequence")
public class SiteService extends BaseEntity{

	/**
	 * 
	 */
	private static final long serialVersionUID = -3929195901282530124L;
	
	/** 网点名称 */
	private String serviceName;
	/** 联系人 */
	private String serviceMan;

	/** 联系电话 */
	private String servicePhone;

	/** 邮箱 */
	private String serviceEmail;

	/** 固定电话 */
	private String serviceTel;

	/** 省份 */
	private String serviceProvince;

	/** 市 */
	private String servicePcity;
	
	/** 区 */
	private String serviceCity;
	
	/** 地址 */
	private String serviceAddress;
	
	/** 网点是否可用*/
	private Integer serviceDisabled;
	
	/** 是否安装网点 */
	private Integer serviceIsinstall;
	
	/** 是否维修网点 */
	private Integer serviceIsmaintenance;
	
	/** 网点是否门店 */
	private Integer serviceIsstore;

	@Column(nullable = true)
	public String getServiceName() {
		return serviceName;
	}

	public void setServiceName(String serviceName) {
		this.serviceName = serviceName;
	}

	@Column(nullable = true)
	public String getServiceMan() {
		return serviceMan;
	}

	public void setServiceMan(String serviceMan) {
		this.serviceMan = serviceMan;
	}

	@Column(nullable = true)
	public String getServicePhone() {
		return servicePhone;
	}

	public void setServicePhone(String servicePhone) {
		this.servicePhone = servicePhone;
	}

	@Column(nullable = true)
	public String getServiceEmail() {
		return serviceEmail;
	}

	public void setServiceEmail(String serviceEmail) {
		this.serviceEmail = serviceEmail;
	}

	@Column(nullable = true)
	public String getServiceTel() {
		return serviceTel;
	}

	public void setServiceTel(String serviceTel) {
		this.serviceTel = serviceTel;
	}

	@Column(nullable = true)
	public String getServiceProvince() {
		return serviceProvince;
	}

	public void setServiceProvince(String serviceProvince) {
		this.serviceProvince = serviceProvince;
	}

	@Column(nullable = true)
	public String getServicePcity() {
		return servicePcity;
	}

	public void setServicePcity(String servicePcity) {
		this.servicePcity = servicePcity;
	}

	@Column(nullable = true)
	public String getServiceCity() {
		return serviceCity;
	}

	public void setServiceCity(String serviceCity) {
		this.serviceCity = serviceCity;
	}

	@Column(nullable = true)
	public String getServiceAddress() {
		return serviceAddress;
	}

	public void setServiceAddress(String serviceAddress) {
		this.serviceAddress = serviceAddress;
	}

	@Column(nullable = true)
	public Integer getServiceDisabled() {
		return serviceDisabled;
	}

	public void setServiceDisabled(Integer serviceDisabled) {
		this.serviceDisabled = serviceDisabled;
	}

	@Column(nullable = true)
	public Integer getServiceIsinstall() {
		return serviceIsinstall;
	}

	public void setServiceIsinstall(Integer serviceIsinstall) {
		this.serviceIsinstall = serviceIsinstall;
	}

	@Column(nullable = true)
	public Integer getServiceIsmaintenance() {
		return serviceIsmaintenance;
	}

	public void setServiceIsmaintenance(Integer serviceIsmaintenance) {
		this.serviceIsmaintenance = serviceIsmaintenance;
	}

	@Column(nullable = true)
	public Integer getServiceIsstore() {
		return serviceIsstore;
	}

	public void setServiceIsstore(Integer serviceIsstore) {
		this.serviceIsstore = serviceIsstore;
	}
	

	


}
