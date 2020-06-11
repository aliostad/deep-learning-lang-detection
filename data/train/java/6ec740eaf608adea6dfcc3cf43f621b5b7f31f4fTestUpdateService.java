/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package tunipharma.testes;

/**
 *
 * @author ali
 */


import tunipharma.dao.ServicePharmcieDAO;
import tunipharma.entities.PharmacieService;
import tunipharma.services.ServicePharmcieService;


public class TestUpdateService {
    
    public static void main(String[] args) {

        PharmacieService service = new PharmacieService();
        ServicePharmcieDAO serviceDAO = new ServicePharmcieDAO();
        ServicePharmcieService servicePharmcieService = new ServicePharmcieService();
        service = servicePharmcieService.findServiceByLibellle("infirmerie");
        service.setLibelleService("7IIIIIIIIIIIIIIIT");
        serviceDAO.updateService(service);

    }
    
    
    
    
    
}
