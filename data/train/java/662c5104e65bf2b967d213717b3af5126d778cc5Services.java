package net.sinclairstudios.grindcount.service;

public class Services implements Service {

    private final DerbyService derbyService;
    private final JettyService jettyService;

    public Services(DerbyService derbyService, JettyService jettyService) {
        this.derbyService = derbyService;
        this.jettyService = jettyService;
    }

    @Override
    public void start() throws Exception {
        derbyService.start();
        jettyService.start();
    }

    @Override
    public void stop() throws Exception {
        jettyService.stop();
        derbyService.stop();
    }
}
