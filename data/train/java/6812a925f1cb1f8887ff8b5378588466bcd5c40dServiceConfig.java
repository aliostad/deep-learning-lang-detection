package dk.drb.blacktiger.config;

import dk.drb.blacktiger.service.CallInformationService;
import dk.drb.blacktiger.service.ConferenceService;
import dk.drb.blacktiger.service.PhonebookService;
import dk.drb.blacktiger.service.SipAccountService;
import dk.drb.blacktiger.service.SummaryService;
import dk.drb.blacktiger.service.SystemService;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Import;

/**
 * Configuration for Service classes.
 */
@Configuration
@Import({RepositoryConfig.class})
public class ServiceConfig {
    
    @Bean
    public CallInformationService callInformationService() {
        return new CallInformationService();
    }

    @Bean
    public ConferenceService conferenceService() {
        ConferenceService service = new ConferenceService();
        service.setHandleMuteness(true);
        return service;
    }

    @Bean
    public PhonebookService phonebookService() {
        return new PhonebookService();
    }

    @Bean SipAccountService sipAccountService() {
        return new SipAccountService();
    }
    
    @Bean SummaryService summaryService() {
        return new SummaryService();
    }
    
    @Bean SystemService systemService() {
        return new SystemService();
    }
    
}
