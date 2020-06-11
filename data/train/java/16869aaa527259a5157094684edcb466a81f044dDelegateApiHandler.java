package ddth.dasp.framework.api;

import ddth.dasp.common.api.ApiException;
import ddth.dasp.common.api.IApiHandler;

public class DelegateApiHandler extends AbstractApiHandler {

	private IApiHandler apiHandler;

	public DelegateApiHandler() {
	}

	public DelegateApiHandler(IApiHandler apiHandler) {
		setApiHandler(apiHandler);
	}

	public IApiHandler getApiHandler() {
		return apiHandler;
	}

	public void setApiHandler(IApiHandler apiHandler) {
		this.apiHandler = apiHandler;
	}

	/**
	 * {@inheritDoc}
	 */
	@Override
	protected Object internalCallApi(Object params, String authKey,
			String remoteAddr) throws ApiException {
		return apiHandler.callApi(params, authKey, remoteAddr);
	}
}
