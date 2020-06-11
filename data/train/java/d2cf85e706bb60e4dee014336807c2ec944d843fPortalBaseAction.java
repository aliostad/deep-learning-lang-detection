/**
 * Copyright (c) 2010 Abbcc Corp.
 * No 225,Wen Yi RD, Hang Zhou, Zhe Jiang, China.
 * All rights reserved.
 *
 * "PortalBaseAction.java is the copyrighted,
 * proprietary property of Abbcc Company and its
 * subsidiaries and affiliates which retain all right, title and interest
 * therein."
 * 
 * Revision History
 *
 * Date              Programmer                   Notes
 * ---------    ---------------------  --------------------------------------------
 * 2010-3-1           baowp                      initial
 */

package com.abbcc.module.portal;

import com.abbcc.action.BaseAction;
import com.abbcc.common.PaginationSupport;
import com.abbcc.service.EnterpriseService;
import com.abbcc.service.NewsService;
import com.abbcc.service.ProductService;
import com.abbcc.service.SupplyService;
import com.abbcc.service.SyscodeService;
import com.abbcc.service.UserService;

@SuppressWarnings("serial")
public abstract class PortalBaseAction<T> extends BaseAction<T> {

	protected SyscodeService syscodeService;
	protected UserService userService;
	protected EnterpriseService enterpriseService;
	protected ProductService productService;
	protected SupplyService supplyService;
	protected NewsService newsService;

	public PaginationSupport enterpriseItems;

	public void setProductService(ProductService productService) {
		this.productService = productService;
	}

	public void setSupplyService(SupplyService supplyService) {
		this.supplyService = supplyService;
	}

	public void setNewsService(NewsService newsService) {
		this.newsService = newsService;
	}

	public void setEnterpriseService(EnterpriseService enterpriseService) {
		this.enterpriseService = enterpriseService;
	}

	public void setSyscodeService(SyscodeService syscodeService) {
		this.syscodeService = syscodeService;
	}

	public void setUserService(UserService userService) {
		this.userService = userService;
	}
}
