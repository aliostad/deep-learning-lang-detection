package au.net.istomisgood.bs.service.device;

import javax.ejb.Stateless;
import javax.inject.Inject;

@Stateless
public class DeviceService {
	
	private DeviceLatLongRepository deviceLatLongRepository;
	private DeviceDetailRepository deviceDetailRepository;
	private DeviceTypeRepository deviceTypeRepository;
	
	@Inject
	public DeviceService(DeviceDetailRepository deviceDetailRepository, DeviceLatLongRepository deviceLatLongRepository, DeviceTypeRepository deviceTypeRepository) {
		super();
		this.deviceDetailRepository = deviceDetailRepository;
		this.deviceLatLongRepository = deviceLatLongRepository;
		this.deviceTypeRepository = deviceTypeRepository;
	}

	public DeviceLatLongRepository getDeviceLatLongRepository() {
		return deviceLatLongRepository;
	}

	public DeviceDetailRepository getDeviceDetailRepository() {
		return deviceDetailRepository;
	}

	public DeviceTypeRepository getDeviceTypeRepository() {
		return deviceTypeRepository;
	}
		
}
