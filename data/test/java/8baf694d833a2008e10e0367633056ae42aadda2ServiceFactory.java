package com.finchuk.services.factory;

import com.finchuk.services.AuthService;
import com.finchuk.services.impl.*;

/**
 * Created by root on 08.04.17.
 */
public class ServiceFactory {
    static private AirlineService airlineService;
    static private AirportService airportService;
    static private AuthService authService;
    static private FlightService flightService;
    static private RouteService routeService;
    static private TicketService ticketService;
    static private UserService userService;
    static private PaymentService paymentService;
    static {
        airlineService = new AirlineService();
        airportService = new AirportService();
        authService = new AuthServiceImpl();
        flightService = new FlightService();
        routeService = new RouteService();
        ticketService = new TicketService();
        userService = new UserService();
        paymentService = new PaymentService();


        authService.init();
        flightService.init();
        routeService.init();
        ticketService.init();
        paymentService.init();
    }

    static public AirlineService getAirlineService() {
        return airlineService;
    }


    static public AirportService getAirportService() {
        return airportService;
    }


    static public AuthService getAuthService() {
        return authService;
    }


    static public FlightService getFlightService() {
        return flightService;
    }


    static public RouteService getRouteService() {
        return routeService;
    }


    static public TicketService getTicketService() {
        return ticketService;
    }


    static public UserService getUserService() {
        return userService;
    }


    static public PaymentService getPaymentService() {
        return paymentService;
    }
}
