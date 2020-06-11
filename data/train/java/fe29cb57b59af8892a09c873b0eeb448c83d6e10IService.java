/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package timeAttendance.Service;

import java.util.List;
import org.springframework.transaction.annotation.Transactional;
import timeAttendance.data.Service;

/**
 *
 * @author simo
 */
@Transactional
public interface IService {
    
    public Service createService(Service service);
    public Service updateService(Service service);
    public Service deleteService(Service service);
    public Service findServiceById(Long Id);
    public List<Service> findAllService();
    
    
}

