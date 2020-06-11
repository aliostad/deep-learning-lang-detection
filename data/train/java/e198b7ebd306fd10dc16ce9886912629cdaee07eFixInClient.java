package com.pinganfu.finexchangeout.service.integration;

import com.pinganfu.finexchangein.service.facade.CollectService;
import com.pinganfu.finexchangein.service.facade.DepositService;



/**
 * 金融流入客户端
 * 
 * @author johnny
 * @version $Id: FixInClient.java, v 0.1 2014-8-14 下午1:48:10 johnny Exp $
 */
public class FixInClient {
    /**
     * 充值服务.
     */
    private DepositService depositService;
    /**
     * 代扣服务
     */
    private CollectService collectService;

	public DepositService getDepositService() {
		return depositService;
	}

	public void setDepositService(DepositService depositService) {
		
		this.depositService = depositService;
	}

	public CollectService getCollectService() {
		return collectService;
	}

	public void setCollectService(CollectService collectService) {
		this.collectService = collectService;
	}
    

}
