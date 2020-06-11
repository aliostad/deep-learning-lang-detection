package com.dennytech.common.app;

import android.support.v4.app.Fragment;

import com.dennytech.common.service.configservice.ConfigService;
import com.dennytech.common.service.dataservice.cache.CacheService;
import com.dennytech.common.service.dataservice.http.HttpService;
import com.dennytech.common.service.dataservice.image.ImageService;
import com.dennytech.common.service.dataservice.mapi.AutoReleaseMApiService;
import com.dennytech.common.service.dataservice.mapi.MApiService;

public class CLFragment extends Fragment {

	@Override
	public void onDestroy() {
		if (autoReleaseMApiService != null) {
			autoReleaseMApiService.onDestory();
		}

		super.onDestroy();
	}

	private AutoReleaseMApiService autoReleaseMApiService;

	public Object getService(String name) {
		if ("mapi".equals(name)) {
			if (autoReleaseMApiService == null) {
				MApiService orig = (MApiService) CLApplication.instance()
						.getService("mapi");
				autoReleaseMApiService = new AutoReleaseMApiService(
						CLFragment.this, orig);
			}
			return autoReleaseMApiService;
		}
		return CLApplication.instance().getService(name);
	}

	private HttpService httpService;

	public HttpService httpService() {
		if (httpService == null) {
			httpService = (HttpService) getService("http");
		}
		return httpService;
	}

	private ImageService imageService;

	public ImageService imageService() {
		if (imageService == null) {
			imageService = (ImageService) getService("image");
		}
		return imageService;
	}

	private CacheService cacheService;

	public CacheService cacheService() {
		if (cacheService == null) {
			cacheService = (CacheService) getService("mapi_cache");
		}
		return cacheService;
	}

	private MApiService mapiService;

	public MApiService mapiService() {
		if (mapiService == null) {
			mapiService = (MApiService) getService("mapi");
		}
		return mapiService;
	}

	private ConfigService configService;

	public ConfigService configService() {
		if (configService == null) {
			configService = (ConfigService) getService("config");
		}
		return configService;
	}

}
