/*
 * $Id: $
 * $Revision: $
 * $Author: $
 */

package fr.afnic.commons.services.facade;

import fr.afnic.commons.services.IAccountService;
import fr.afnic.commons.services.IApplicationService;
import fr.afnic.commons.services.IAuthorizationPreliminaryExamService;
import fr.afnic.commons.services.IAuthorizationRequestService;
import fr.afnic.commons.services.IAuthorizationService;
import fr.afnic.commons.services.IBillingService;
import fr.afnic.commons.services.IBusinessRuleService;
import fr.afnic.commons.services.ICustomerContactService;
import fr.afnic.commons.services.ICustomerService;
import fr.afnic.commons.services.IDictionaryService;
import fr.afnic.commons.services.IDocumentService;
import fr.afnic.commons.services.IDomainPortfolioService;
import fr.afnic.commons.services.IDomainService;
import fr.afnic.commons.services.IEmailService;
import fr.afnic.commons.services.IEppService;
import fr.afnic.commons.services.IFaxService;
import fr.afnic.commons.services.ILegalService;
import fr.afnic.commons.services.ILoggerService;
import fr.afnic.commons.services.IOldDocumentService;
import fr.afnic.commons.services.IOperationFormService;
import fr.afnic.commons.services.IOperationService;
import fr.afnic.commons.services.IPostalAddressService;
import fr.afnic.commons.services.IProfileService;
import fr.afnic.commons.services.IPublicLegalStructureService;
import fr.afnic.commons.services.IQualificationService;
import fr.afnic.commons.services.IQualityService;
import fr.afnic.commons.services.IRequestService;
import fr.afnic.commons.services.IResultListService;
import fr.afnic.commons.services.IStatisticService;
import fr.afnic.commons.services.ITicketService;
import fr.afnic.commons.services.ITradeService;
import fr.afnic.commons.services.IUserService;
import fr.afnic.commons.services.IWhoisContactService;

/**
 * Facade disposant de setter pour initialiser les implémentations des différents service<br/>
 * 
 * @author ginguene
 * 
 */
public class CustomAppServiceFacade extends AppServiceFacade {

    /**
     * Définit que la facade à utiliser est celle-ci. *
     * 
     */
    public void use() {
        AppServiceFacade.use(this);
    }

    public static void setLoggerService(ILoggerService loggerService) {
        AppServiceFacade.staticLoggerService = loggerService;
    }

    /**
     * Fonction utilisée dans le cadre de tests.<br/>
     * Permet de récupérer le CustomServiceFacade utilisée par service facade.<br/>
     * si le singleton de ServiceFacade, n'est pas de la classe CustomServiceFacade, retourne null.
     * 
     * @return
     */
    public static CustomAppServiceFacade getInstance() {
        AppServiceFacade instance = AppServiceFacade.getInstance();
        if (instance instanceof CustomAppServiceFacade) {
            return (CustomAppServiceFacade) instance;
        } else {
            return null;
        }
    }

    public void setPostalAddressService(IPostalAddressService postalAddressService) {
        provider.setPostalAddressService(postalAddressService);
    }

    public void setAuthorizationService(IAuthorizationService authorizationService) {
        provider.setAuthorizationService(authorizationService);
    }

    public void setAuthorizationRequestService(IAuthorizationRequestService authorizationRequestService) {
        provider.setAuthorizationRequestService(authorizationRequestService);
    }

    public void setAuthorizationPreliminaryExamService(IAuthorizationPreliminaryExamService authorizationPreliminaryExamService) {
        provider.setAuthorizationPreliminaryExamService(authorizationPreliminaryExamService);
    }

    public void setWhoisContactService(IWhoisContactService whoisContactService) {
        provider.setWhoisContactService(whoisContactService);
    }

    public void setDictionaryService(IDictionaryService dictionaryService) {
        provider.setDictionaryService(dictionaryService);
    }

    public void setBillingService(IBillingService billingService) {
        provider.setBillingService(billingService);
    }

    public void setOldDocumentService(IOldDocumentService oldDocumentService) {
        provider.setOldDocumentService(oldDocumentService);
    }

    public void setDocumentService(IDocumentService documentService) {
        provider.setDocumentService(documentService);
    }

    public void setDomainService(IDomainService domainService) {
        provider.setDomainService(domainService);
    }

    public void setFaxService(IFaxService faxService) {
        provider.setFaxService(faxService);
    }

    public void setEmailService(IEmailService mailService) {
        provider.setEmailService(mailService);
    }

    public void setOperationFormService(IOperationFormService operationFormService) {
        provider.setOperationFormService(operationFormService);
    }

    public void setEppService(IEppService eppService) {
        provider.setEppService(eppService);
    }

    public void setPublicLegalStructureService(IPublicLegalStructureService publicLegalStructureService) {
        provider.setPublicLegalStructureService(publicLegalStructureService);
    }

    public void setQualityService(IQualityService qualityService) {
        provider.setQualityService(qualityService);
    }

    public void setRequestService(IRequestService requestService) {
        provider.setRequestService(requestService);
    }

    public void setStatisticService(IStatisticService statisticService) {
        provider.setStatisticService(statisticService);
    }

    public void setTicketService(ITicketService ticketService) {
        provider.setTicketService(ticketService);
    }

    public void setTradeService(ITradeService tradeService) {
        provider.setTradeService(tradeService);
    }

    public void setUserService(IUserService userService) {
        provider.setUserService(userService);
    }

    public void setProfileService(IProfileService profileService) {
        provider.setProfileService(profileService);
    }

    public void setApplicationService(IApplicationService applicationService) {
        provider.setApplicationService(applicationService);
    }

    public void setCustomerService(ICustomerService customerService) {
        provider.setCustomerService(customerService);
    }

    public void setCustomerContactService(ICustomerContactService customerContactService) {
        provider.setCustomerContactService(customerContactService);
    }

    public void setDomainPortfolioService(IDomainPortfolioService domainPortfolioService) {
        provider.setDomainPortfolioService(domainPortfolioService);
    }

    public void setAccountService(IAccountService accountService) {
        provider.setAccountService(accountService);
    }

    public void setOperationService(IOperationService operationService) {
        provider.setOperationService(operationService);
    }

    public void setQualificationService(IQualificationService qualificationService) {
        provider.setQualificationService(qualificationService);
    }

    public void setResultListService(IResultListService resultListService) {
        provider.setResultListService(resultListService);
    }

    public void setLegalService(ILegalService legalService) {
        provider.setLegalService(legalService);
    }

    public void setBusinessRuleService(IBusinessRuleService businessRuleService) {
        provider.setBusinessRuleService(businessRuleService);
    }
}
