/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

package com.mycompany.CRMFly.serviceLayer;

import com.mycompany.CRMFly.entities.Contracts;
import com.mycompany.CRMFly.entities.Payments;
import com.mycompany.CRMFly.entities.Requests;
import com.mycompany.CRMFly.entities.SalesProcess;
import com.mycompany.CRMFly.entities.Shipments;
import com.mycompany.CRMFly.hibernateAccess.ProcessDAO;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 *
 * @author Александр
 */
@Service
public class ProcessServiceImpl implements ProcessService {
    
    @Autowired
    ProcessDAO processDAO;
    
       @Transactional
         public List<SalesProcess> getAllProcesses() {
         return processDAO.getAllProcesses();
         }
         
         @Transactional
          public void addProcess(SalesProcess process){
              processDAO.addProcess(process);
          }
          
          
@Transactional
    public List<SalesProcess> listProcesses(){
        return processDAO.listProcesses();
    }

    @Transactional
    public void removeProcess(SalesProcess process){
        processDAO.removeProcess(process);
    }
    
    @Transactional
    public void changeProcess (SalesProcess process){
        processDAO.changeProcess(process);
    }
    
    @Transactional
    public SalesProcess getProcessForId (Long id){
        return processDAO.getProcessForId(id);
    }
    
    @Transactional
    public List<Payments> getProcessPayments (Long id){
        return processDAO.getProcessPayments(id);
    }
     
    @Transactional
     public List<Shipments> getProcessShipments (Long id){
         return processDAO.getProcessShipments(id);
     }
    
    @Transactional
    public void addContractConnection (SalesProcess process, Contracts contract)
    {
        processDAO.addContractConnection(process, contract);
    }
    
    @Transactional
    public void addRequestConnection (SalesProcess process, Requests request)
    {
        processDAO.addRequestConnection(process, request);
    }
    
    @Transactional
    public void addPaymentConnection (SalesProcess process, Payments payment)
    {
        processDAO.addPaymentConnection(process, payment);
    }
    
    @Transactional
    public void addShipmentConnection (SalesProcess process, Shipments shipment){
        processDAO.addShipmentConnection(process, shipment);
    }
    
    @Transactional
    public Requests getProcessRequest (Long id){
        return processDAO.getProcessRequest(id);
    }
     
    @Transactional
     public Contracts getProcessContract (Long id){
         return processDAO.getProcessContract(id);
     }
    

}
