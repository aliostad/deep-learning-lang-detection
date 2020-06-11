package com.inforstack.openstack.billing.process.result;

import com.inforstack.openstack.billing.process.BillingProcess;

public interface BillingProcessResultService {
	
	/**
	 * create billing process result
	 * @param billingProcess
	 * @return
	 */
	public BillingProcessResult createBillingProcessResult(BillingProcess billingProcess);
	
	/**
	 * Find billing process result by id
	 * @param billingProcessId
	 * @return
	 */
	public BillingProcessResult findBillingProcessResult(int billingProcessResultId);

}
