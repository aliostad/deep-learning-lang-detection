/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package Server.Service;

/**
 *
 * @author Son
 */
public class ServiceManager {
    private AdminManagerService adminManagerService;
    private CentreManagerService centreManagerService;
    private EmployeeManagerService empManagerService;
    private ZoneManagerService zoneManagerService;
    private CustomerManagerService custManagerService;

    public ServiceManager() {
        adminManagerService = new AdminManagerService();
        centreManagerService = new CentreManagerService();
        empManagerService = new EmployeeManagerService();
        zoneManagerService = new ZoneManagerService();
        custManagerService = new CustomerManagerService();
    }
    
    public AdminManagerService getAdminManagerService() {
        return adminManagerService;
    }

    public CentreManagerService getCentreManagerService() {
        return centreManagerService;
    }

    public EmployeeManagerService getEmpManagerService() {
        return empManagerService;
    }

    public ZoneManagerService getZoneManagerService() {
        return zoneManagerService;
    }

    public CustomerManagerService getCustManagerService() {
        return custManagerService;
    }
    
}
