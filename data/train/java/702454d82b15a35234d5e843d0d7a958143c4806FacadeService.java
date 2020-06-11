package com.mycompany.tickproject.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 * Created by apple on 09.07.14.
 */
@Service
public class FacadeService {

    private StadiumService stadiumService;
    private SectionOfStadiumService sectionOfStadiumService;
    private RowAndSeatService rowAndSeatService;
    private TicketService ticketService;
    private ActionService actionService;
    private PriceService priceService;


    private CustomerService customerService;

    @Autowired
    public void setStadiumService(StadiumService stadiumService){

        this.stadiumService = stadiumService;
    }
    public StadiumService getStadiumService() { return this.stadiumService; }

    @Autowired
    public void setSectionOfStadiumService(SectionOfStadiumService sectionOfStadiumService){
        this.sectionOfStadiumService = sectionOfStadiumService;
    }
    public SectionOfStadiumService getSectionOfStadiumService() {
        return this.sectionOfStadiumService;
    }

    @Autowired
    public void setRowAndSeatService(RowAndSeatService rowAndSeatService){




        this.rowAndSeatService = rowAndSeatService;
    }
    public RowAndSeatService getRowAndSeatService() {
        return this.rowAndSeatService;
    }

    @Autowired
    public void setTicketService(TicketService ticketService) {
        this.ticketService = ticketService;
    }
    public TicketService getTicketService() {
        return this.ticketService;
    }

    @Autowired
    public void setActionService(ActionService actionService) {
        this.actionService = actionService;
    }
    public ActionService getActionService() {
        return this.actionService;
    }

    @Autowired
    public void setPriceService(PriceService priceService){

        this.priceService = priceService;
    }
    public PriceService getPriceService() { return this.priceService; }

    @Autowired
    public void setCustomerService(CustomerService customerService) {
        this.customerService = customerService;
    }
    public CustomerService getCustomerService() {return this.customerService;}
}
