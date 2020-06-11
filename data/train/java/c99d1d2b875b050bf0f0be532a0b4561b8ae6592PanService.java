package com.tradedoubler.billing.service.pan;

import com.tradedoubler.billing.platform.flowcontroller.ServiceResult;
import com.tradedoubler.billing.service.BillingServiceException;

/**
 * Service interface towards the Pan system.
 *
 * @see PanServiceImpl
 * @author bjoek
 * @since 2012-10-03
 */
public interface PanService {
    ServiceResult updateDisplayTradeDoublerCommission(ServiceResult serviceResult) throws BillingServiceException;

    ServiceResult fetchOrderLines(ServiceResult serviceResult) throws BillingServiceException;

    ServiceResult confirmOrderLines(ServiceResult serviceResult) throws BillingServiceException;

    ServiceResult fetchPrepaymentForecastOrderLines(ServiceResult serviceResult) throws BillingServiceException;

    ServiceResult confirmForecastOrderLines(ServiceResult serviceResult) throws BillingServiceException;

    ServiceResult fetchReadyToInvoice(ServiceResult serviceResult) throws BillingServiceException;

    ServiceResult confirmInvoicingStarted(ServiceResult serviceResult) throws BillingServiceException;

    ServiceResult handleInvoiceForPan(ServiceResult serviceResult) throws BillingServiceException;

    ServiceResult fetchCreatedInvoicingRule(ServiceResult serviceResult) throws BillingServiceException;

    ServiceResult confirmInvoicingRuleProcessed(ServiceResult serviceResult) throws BillingServiceException;

    ServiceResult fetchUpdatedInvoicingRule(ServiceResult serviceResult) throws BillingServiceException;

    ServiceResult fetchResellerClient(ServiceResult serviceResult) throws BillingServiceException;

    ServiceResult confirmResellerClientProcessed(ServiceResult serviceResult) throws BillingServiceException;
}
