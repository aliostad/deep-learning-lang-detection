package com.tradedoubler.billing.service.crm;

import com.tradedoubler.billing.platform.flowcontroller.ServiceResult;
import com.tradedoubler.billing.service.BillingServiceException;

/**
 * Service interface towards the CRM system.
 * @see CrmServiceImpl
 *
 * Date: 2012-06-13
 */
public interface CrmService {

    ServiceResult fetchInvoicingRuleCreated(ServiceResult serviceResult) throws BillingServiceException;

    ServiceResult fetchInvoicingRuleUpdated(ServiceResult serviceResult) throws BillingServiceException;

    ServiceResult fetchAgreementUpdated(ServiceResult serviceResult) throws BillingServiceException;

    ServiceResult deleteOriginalMessage(ServiceResult serviceResult) throws BillingServiceException;

    ServiceResult fetchClientUpdated(ServiceResult serviceResult) throws BillingServiceException;

    ServiceResult fetchSplittingRuleDeleted(ServiceResult serviceResult) throws BillingServiceException;

    ServiceResult fetchInvoiceRecipientDeleted(ServiceResult serviceResult) throws BillingServiceException;

    ServiceResult fetchMarketMessageUpdated(ServiceResult serviceResult) throws BillingServiceException;

    ServiceResult insertPrepaymentForecast(ServiceResult serviceResult) throws BillingServiceException;

    ServiceResult calculatePrepaymentForecasts(ServiceResult serviceResult) throws BillingServiceException;

    ServiceResult transformPrepaymentForecasts(ServiceResult serviceResult);

    ServiceResult insertInvoice(ServiceResult serviceResult) throws BillingServiceException;

    ServiceResult insertUpdateForecast(ServiceResult serviceResult) throws BillingServiceException;
}
