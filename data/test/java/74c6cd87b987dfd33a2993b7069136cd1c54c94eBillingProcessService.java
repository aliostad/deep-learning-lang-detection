package com.inforstack.openstack.billing.process;

import java.util.Date;

import com.inforstack.openstack.billing.process.conf.BillingProcessConfiguration;
import com.inforstack.openstack.billing.process.result.BillingProcessResult;
import com.inforstack.openstack.user.User;

public interface BillingProcessService {
	
	/**
	 * Create billing process
	 * @param billingProcess
	 * @return
	 */
	public BillingProcess createBillingProcess(BillingProcess billingProcess);
	
	/**
	 * Create billing porcess with necessary fields
	 * @param config
	 * @param startTime
	 * @param user
	 * @return
	 */
	public BillingProcess createBillingProcess(BillingProcessConfiguration config, Date startTime, User user);
	
	/**
	 * find billing process
	 * @param billingProcessId
	 * @return
	 */
	public BillingProcess findBillingProcessById(int billingProcessId);
	
	public BillingProcessResult runBillingProcess(BillingProcessConfiguration conf, Boolean autoPay);

	public BillingProcessResult runBillingProcess(BillingProcessConfiguration conf, Integer tenantId, Boolean autoPay);

	public BillingProcessResult runBillingProcess(Integer tenantId, Boolean autoPay);

	public BillingProcessResult runBillingProcessForOrder(int orderId, Boolean autoPay);

	BillingProcessResult processOrder(int orderId, Boolean autoPay, int billingProcessResultId);

	BillingProcessResult createBillingProcessResult(Integer billingProcessConfId);
	
}
