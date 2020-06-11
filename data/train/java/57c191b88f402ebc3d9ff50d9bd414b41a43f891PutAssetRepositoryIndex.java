package at.poquito.assetmanager.jaxrs.jersey;

import at.poquito.assetmanager.AssetRepository;
import at.poquito.assetmanager.util.IFunction;

import com.sun.jersey.api.client.WebResource;

public class PutAssetRepositoryIndex implements IFunction<WebResource, Object> {

	private AssetRepository repository;

	public PutAssetRepositoryIndex(AssetRepository repository) {
		this.repository = repository;
	}

	@Override
	public Object apply(WebResource resource) {
		resource.put(repository);
		return null;
	}

}
