package configs;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;

import repository.PriceListRepository;
import repository.StadiumRepository;
import repository.TicketRepository;

/**
 * Play2 application configuration hook.
 * 
 * @author Mark Wigmans
 * 
 */
@Configuration
@ComponentScan({ "controllers", "services", "repository" })
public class AppConfig {

    // for unclear reasons the singleton objects are not singleton in the unit tests ?!
    private static final StadiumRepository StadiumRepository = new StadiumRepository();
    private static final PriceListRepository PriceListRepository = new PriceListRepository();
    private static final TicketRepository TicketRepository = new TicketRepository();

    @Bean
    StadiumRepository StadiumRepository() {
        return StadiumRepository;
    }

    @Bean
    PriceListRepository PriceListRepository() {
        return PriceListRepository;
    }

    @Bean
    TicketRepository TicketRepository() {
        return TicketRepository;
    }
}