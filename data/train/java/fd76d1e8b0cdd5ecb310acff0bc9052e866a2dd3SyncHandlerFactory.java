package com.csc.agility.adapters.cloud.sampleadapter.sync;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

@Component
public class SyncHandlerFactory {

	@Autowired
	private StorageSyncHandler storageSyncHandler;

	@Autowired
	private AddressRangeSyncHandler addressRangeSyncHandler;

	@Autowired
	private CloudSyncHandler cloudSyncHandler;

	@Autowired
	private CredentialSyncHandler credentialSyncHandler;

	public AddressRangeSyncHandler getAddressRangeSyncHandler() {
		return addressRangeSyncHandler;
	}

	public void setAddressRangeSyncHandler(AddressRangeSyncHandler addressRangeSyncHandler) {
		this.addressRangeSyncHandler = addressRangeSyncHandler;
	}

	public CloudSyncHandler getCloudSyncHandler() {
		return cloudSyncHandler;
	}

	public void setCloudSyncHandler(CloudSyncHandler cloudSyncHandler) {
		this.cloudSyncHandler = cloudSyncHandler;
	}

	public CredentialSyncHandler getCredentialSyncHandler() {
		return credentialSyncHandler;
	}

	public void setCredentialSyncHandler(CredentialSyncHandler credentialSyncHandler) {
		this.credentialSyncHandler = credentialSyncHandler;
	}

	public ImageSyncHandler getImageSyncHandler() {
		return imageSyncHandler;
	}

	public void setImageSyncHandler(ImageSyncHandler imageSyncHandler) {
		this.imageSyncHandler = imageSyncHandler;
	}

	public InstanceSyncHandler getInstanceSyncHandler() {
		return instanceSyncHandler;
	}

	public void setInstanceSyncHandler(InstanceSyncHandler instanceSyncHandler) {
		this.instanceSyncHandler = instanceSyncHandler;
	}

	public LocationSyncHandler getLocationSyncHandler() {
		return locationSyncHandler;
	}

	public void setLocationSyncHandler(LocationSyncHandler locationSyncHandler) {
		this.locationSyncHandler = locationSyncHandler;
	}

	public ModelSyncHandler getModelSyncHandler() {
		return modelSyncHandler;
	}

	public void setModelSyncHandler(ModelSyncHandler modelSyncHandler) {
		this.modelSyncHandler = modelSyncHandler;
	}

	public NetworkSyncHandler getNetworkSyncHandler() {
		return networkSyncHandler;
	}

	public void setNetworkSyncHandler(NetworkSyncHandler networkSyncHandler) {
		this.networkSyncHandler = networkSyncHandler;
	}

	public RepositorySyncHandler getRepositorySyncHandler() {
		return repositorySyncHandler;
	}

	public void setRepositorySyncHandler(RepositorySyncHandler repositorySyncHandler) {
		this.repositorySyncHandler = repositorySyncHandler;
	}

	public void setStorageSyncHandler(StorageSyncHandler storageSyncHandler) {
		this.storageSyncHandler = storageSyncHandler;
	}

	@Autowired
	private ImageSyncHandler imageSyncHandler;

	@Autowired
	private InstanceSyncHandler instanceSyncHandler;

	@Autowired
	private LocationSyncHandler locationSyncHandler;

	@Autowired
	private ModelSyncHandler modelSyncHandler;

	@Autowired
	private NetworkSyncHandler networkSyncHandler;

	@Autowired
	private RepositorySyncHandler repositorySyncHandler;

	public StorageSyncHandler getStorageSyncHandler() {
		return storageSyncHandler;
	}

}
