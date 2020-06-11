package me.smartco.akstore.integration;

import me.smartco.akstore.store.service.MallService;
import me.smartco.akstore.store.service.PartnerService;
import me.smartco.akstore.transaction.service.TransactionService;
import me.smartco.akstore.user.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.stereotype.Component;

/**
 * Created by libin on 15-2-9.
 */
@Component
public class ServiceFacade {
    @Autowired
    private UserService userService;
    @Autowired
    private MallService mallService;
    @Autowired
    private PartnerService partnerService;
    @Autowired
    private TransactionService transactionService;

    public UserService getUserService() {
        return userService;
    }

    public MallService getMallService() {
        return mallService;
    }

    public PartnerService getPartnerService() {
        return partnerService;
    }

    public TransactionService getTransactionService() {
        return transactionService;
    }

    @Bean
    public CompositeService getCompositeService(){
        return new CompositeService(userService,mallService,partnerService,transactionService);
    }
}
