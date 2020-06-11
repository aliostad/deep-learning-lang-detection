package com.cecere.mediacloud.service;

import java.util.List;

import com.cecere.dlna.domain.Content;
import com.cecere.dlna.domain.Device;
import com.cecere.dlna.domain.Renderer;
import com.cecere.repository.Repository;

public class DeviceServiceImpl implements DeviceService {

	
	private Repository<Device> deviceRepository;
	private Repository<Renderer> rendererRepository;
	
	public DeviceServiceImpl(Repository<Device> deviceRepository,Repository<Renderer> rendererRepository){
		this.deviceRepository = deviceRepository;
		this.rendererRepository = rendererRepository;
	}
	
	@Override
	public List<Device> findAllDevices() {
		return deviceRepository.findAll();
	}

	@Override
	public List<Renderer> findAllRenderers() {
		return rendererRepository.findAll();
	}

	@Override
	public void playMediaOnRenderer(Renderer renderer,Content content){
		renderer.playContent(content);
	}
	
}
